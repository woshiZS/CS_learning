#include "tcp_sender.hh"

#include "tcp_config.hh"

#include <random>

// Dummy implementation of a TCP sender

// For Lab 3, please replace with a real implementation that passes the
// automated checks run by `make check_lab3`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

//! \param[in] capacity the capacity of the outgoing byte stream
//! \param[in] retx_timeout the initial amount of time to wait before retransmitting the oldest outstanding segment
//! \param[in] fixed_isn the Initial Sequence Number to use, if set (otherwise uses a random ISN)
TCPSender::TCPSender(const size_t capacity, const uint16_t retx_timeout, const std::optional<WrappingInt32> fixed_isn)
    : _isn(fixed_isn.value_or(WrappingInt32{random_device()()}))
    , _initial_retransmission_timeout{retx_timeout}
    , _current_retransmission_timeout{retx_timeout}
    , _stream(capacity) {}

uint64_t TCPSender::bytes_in_flight() const { return _next_seqno - _ack_seqno; }

void TCPSender::fill_window() {
    // fill as much as we can but no more than MAX_PAYLOAD_SIZE
    while(true){
        switch (_state)
        {
        case state::CLOSED :
            {
            // need to check if has content has arrived and append a syn
            TCPSegment seg;
            seg.header().syn = true;
            seg.header().seqno = wrap(_next_seqno, _isn);
            _segments_out.push(seg);
            // copy internal
            _segments_buffer.push(seg);
            ++_next_seqno;
            _state = state::SYN_SENT;
            _timer_swtitch = _timer_swtitch == false ? true : _timer_swtitch;
            }
            return;
            break;

        case state::SYN_ACKED:
            {// send as many bytes as possible, stream.size(), TCPConfig::MAX_PAYLOAD_SIZE, window size - _nextseqno
            if(_ack_seqno + _win_size <= _next_seqno && _win_size != 0)return;
            TCPSegment seg;
            seg.header().seqno = wrap(_next_seqno, _isn);
            // todo: may have to deal with win_size == 0 condition!!!!!!!
            uint64_t real_win_size = _win_size == 0 ? 1 : _win_size;
            size_t payloadLen = min(TCPConfig::MAX_PAYLOAD_SIZE, min(_stream.buffer_size(), _ack_seqno + real_win_size - _next_seqno));
            string content = _stream.read(payloadLen);
            seg.payload() = Buffer(move(content));
            if(_stream.input_ended() && _stream.buffer_size() == 0 && _ack_seqno + real_win_size > _next_seqno + payloadLen){
                seg.header().fin = true;
                _state = state::FIN_SENT;
            }
            if(seg.length_in_sequence_space() == 0)return;
            _next_seqno += seg.length_in_sequence_space();
            _segments_out.push(seg);
            _segments_buffer.push(seg);
            _timer_swtitch = true;
            if(_win_size == 0)return;
            }
            break;

        default:
            return;
        }
    }
}

//! \param ackno The remote receiver's ackno (acknowledgment number)
//! \param window_size The remote receiver's advertised window size
void TCPSender::ack_received(const WrappingInt32 ackno, const uint16_t window_size) {
    // update data and if there are new spaces left we need to fill the window again.
    // update the ack no when we send the outgoing package the acknumber is right
    _win_size = window_size;
    uint64_t temp_ack = unwrap(ackno, _isn, _next_seqno);
    if(temp_ack <= _ack_seqno)return;
    _ack_seqno = temp_ack;
    _current_retransmission_timeout  = _initial_retransmission_timeout;// 7a
    _total_time = 0;
    conseRetranTimes = 0;// 7c
    // if current state is SYN sent, change it to syn acked
    switch (_state)
    {
    case state::SYN_SENT:
        _state = state::SYN_ACKED;
        break;
    
    case state::FIN_SENT:
        _state = state::FIN_ACKED;
        break;

    default:
        break;
    }
    // check for already acknowledged segment
    while(!_segments_buffer.empty()){
        auto seg = _segments_buffer.front();
        uint64_t seq_64 = unwrap(seg.header().seqno, _isn, _next_seqno);
        if(seq_64 + seg.length_in_sequence_space() <= _ack_seqno){
           _segments_buffer.pop();
        }
        else
            break;
    }
    // fully acknowledged and timer is on, turn off timer 
    // todo: need to modify other time options.
    if(_segments_buffer.empty() && _timer_swtitch){
        _timer_swtitch = false;
    }
    if(_ack_seqno + _win_size >= _next_seqno){
        // restart the timer in the fill_window() function.
        fill_window();
    }
}

//! \param[in] ms_since_last_tick the number of milliseconds since the last call to this method
void TCPSender::tick(const size_t ms_since_last_tick) { 
    if(_timer_swtitch == false)return;
    _total_time += ms_since_last_tick;
    if(_total_time >= _current_retransmission_timeout && !_segments_buffer.empty()){
        _segments_out.push(_segments_buffer.front());
        if(_win_size !=0){
            _current_retransmission_timeout *= 2;
            conseRetranTimes += 1;
        }
        _total_time = 0;
        _timer_swtitch = true;
    }
    if(_segments_buffer.empty()){
        _timer_swtitch = false;
        _total_time = 0;
        conseRetranTimes = 0;
    }
 }

unsigned int TCPSender::consecutive_retransmissions() const { return conseRetranTimes; }

void TCPSender::send_empty_segment() {
    // do not need to push to the queue
    TCPSegment seg;
    // transform seq to Wrap32
    seg.header().seqno = wrap(_next_seqno, _isn);
    // need  to push but no need to store it elsewhere
    _segments_out.push(seg);
}
