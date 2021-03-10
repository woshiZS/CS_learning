#include "tcp_receiver.hh"

// Dummy implementation of a TCP receiver

// For Lab 2, please replace with a real implementation that passes the
// automated checks run by `make check_lab2`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

void TCPReceiver::segment_received(const TCPSegment &seg) {
    //different situations must be included
    switch (_state){
    case state::listen :
        if(seg.header().syn == false)return;
        // do something like initialization, 
        _state = state::syn_recv;
        isn = seg.header().seqno;
        // accept message when first handshake
        if(seg.payload().size()>0){
            uint64_t curIndex = _reassembler.stream_out().buffer_size() + _reassembler.stream_out().bytes_read() + 1ul;
            // need to get the real index in 64 bit
            uint64_t index = unwrap(WrappingInt32 {seg.header().seqno.raw_value() + 1}, isn, curIndex);
            _reassembler.push_substring(seg.payload().copy(), index - 1ul, seg.header().fin);
        }
        if(seg.header().fin){
            // can we directly end input here?(yes) do we need to accept payload in the first packet?(yes)
            stream_out().end_input();
            _state = state::fin_recv;
        }
        break;

    case state::syn_recv :{
        // if fin is not set, then receive value and push to the string
        if(seg.header().syn)return;
        uint64_t curIndex = _reassembler.stream_out().buffer_size() + _reassembler.stream_out().bytes_read() + 1ul;
        // need to get the real index in 64 bit
        uint64_t index = unwrap(seg.header().seqno, isn, curIndex);
        _reassembler.push_substring(seg.payload().copy(), index - 1ul, seg.header().fin);
        // check if the inner stream ends, header state can not be fin because the latter half main contian the ending
        if(_reassembler.stream_out().input_ended()) _state = state::fin_recv;
        }
        break;

    default:
        return;
        break;
    }
}

optional<WrappingInt32> TCPReceiver::ackno() const { 
    if(_state == state::listen)return {};
    // return the first unreassemble byte index
    const ByteStream innerStream = _reassembler.stream_out();
    // wrap converts absolute uint64_t to 32 bit
    uint64_t realLen = innerStream.bytes_read() + innerStream.buffer_size() + 1ul + (_state == state::fin_recv ? 1ul : 0);
    return wrap(realLen, isn);
}

size_t TCPReceiver::window_size() const {
    // fin should return 0, and when listen  
    if(_state == state::fin_recv)return 0;
    return _capacity - _reassembler.stream_out().buffer_size();
}
