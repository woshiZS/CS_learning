#include "stream_reassembler.hh"

// Dummy implementation of a stream reassembler.

// For Lab 1, please replace with a real implementation that passes the
// automated checks run by `make check_lab1`.

// You will need to add private members to the class declaration in `stream_reassembler.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

StreamReassembler::StreamReassembler(const size_t capacity) : _output(capacity), _capacity(capacity) {}

//! \details This function accepts a substring (aka a segment) of bytes,
//! possibly out-of-order, from the logical stream, and assembles any newly
//! contiguous substrings and writes them into the output stream in order.
void StreamReassembler::push_substring(const string &data, const size_t index, const bool eof) {
    size_t upperBound = _output.bytes_read() + _capacity;
    size_t desiredIndex = _output.bytes_read() + _output.buffer_size();
    // if 
    if(index > upperBound)return;
    if(index + data.size() <= desiredIndex){
        if(eof && unassemble == 0){
            _output.end_input();
        }
        return;
    }
    size_t start = index >= desiredIndex ? index : desiredIndex;
    size_t len = index + data.size() - start;
    bool realEOF = eof;
    if(index + data.size() > upperBound){
        len = upperBound - start;
        realEOF = false;
    }
    // CACHE AND MERGE IN THIS STEP
    storeInCache(data.substr(start - index, len), start, realEOF);
    // check from the cache if the match the desired Index greater than the begin index
    auto it = cache.begin();
    if(desiredIndex >= it->_index){
        _output.write(it->_innerStr.substr(desiredIndex - it->_index, it->_innerStr.size() + it->_index - desiredIndex));
        unassemble -= it->_innerStr.size();
        if(it->_eof&&unassemble==0)_output.end_input();
        cache.erase(it);
    }
}

size_t StreamReassembler::unassembled_bytes() const { return unassemble; }

bool StreamReassembler::empty() const { return unassemble == 0; }

int StreamReassembler::merge(list<cacheItem>::iterator first, list<cacheItem>::iterator second){
    // the second condition cant be less than or equal, equal condition can be concatenate
    if(second == cache.end() || first->_index + first->_innerStr.size() < second->_index)return -1;
    if(first->_index + first->_innerStr.size() >= second->_index + second->_innerStr.size())return second->_innerStr.size();
    first->_eof = second->_eof;
    size_t head = first->_index + first->_innerStr.size() - second->_index;
    size_t len = second->_innerStr.size() - head;
    first->_innerStr += second->_innerStr.substr(head, len);
    return head;
}

void StreamReassembler::storeInCache(const string& data, size_t index, bool eof){
    list<cacheItem>::iterator startPos = cache.end();
    list<cacheItem>::iterator it;
    for(it = cache.begin(); it != cache.end(); ++it){
        // find the pos where index less than the right bound
        if(index <= it->_index){
            startPos = it;
            break;
        }
    }
    auto selfPos = cache.emplace(startPos, index, data, eof);
    unassemble += data.size();
    // from self continue to merge and delete the merged elements outside the for loop.
    for( ; it != cache.end(); ++it){
        int mergedBytes = merge(selfPos, it);
        if(mergedBytes == -1) break;
        unassemble -= mergedBytes;
    }
    cache.erase(startPos, it);
    // may overlap with the former node
    if(selfPos != cache.begin()){
        it = selfPos;
        int mergedBytes = merge(--it, selfPos);
        if(mergedBytes>0){
            cache.erase(selfPos);
            unassemble -= mergedBytes;
        }
    }
}