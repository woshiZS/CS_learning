#include "byte_stream.hh"

// Dummy implementation of a flow-controlled in-memory byte stream.

// For Lab 0, please replace with a real implementation that passes the
// automated checks run by `make check_lab0`.

// You will need to add private members to the class declaration in `byte_stream.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

ByteStream::ByteStream(const size_t capacity_):capacity(capacity_) {
}

size_t ByteStream::write(const string &data) {
    size_t writeLen = data.size();
    writeLen = (writeLen <= (capacity - buffer.size())) ? writeLen : (capacity - buffer.size());
    for(size_t i = 0; i < writeLen; ++i){
        buffer.push_back(data[i]);
    }
    totalWrite += writeLen;
    return writeLen;
}

//! \param[in] len bytes will be copied from the output side of the buffer
string ByteStream::peek_output(const size_t len) const {
    size_t peekLen = (len <= buffer.size()) ? len : buffer.size();
    string ans(buffer.begin(), buffer.begin() + peekLen);
    return ans;
}

//! \param[in] len bytes will be removed from the output side of the buffer
void ByteStream::pop_output(const size_t len) {
    size_t popLen = (len <= buffer.size()) ? len : buffer.size();
    for(size_t i = 0; i < popLen; ++i){
        buffer.pop_front();
    }
    totalRead += popLen;
}

//! Read (i.e., copy and then pop) the next "len" bytes of the stream
//! \param[in] len bytes will be popped and returned
//! \returns a string
std::string ByteStream::read(const size_t len) {
    string ans;
    size_t readLen = (len <= buffer.size()) ? len : buffer.size();
    for(size_t i = 0; i < readLen; ++i){
        ans += buffer[i];
    }
    for(size_t i = 0; i < readLen; ++i){
        buffer.pop_front();
    }
    totalRead += readLen;
    return ans;
}

void ByteStream::end_input() { inputEndFlag = true; }

bool ByteStream::input_ended() const { return inputEndFlag; }

size_t ByteStream::buffer_size() const { return buffer.size(); }

bool ByteStream::buffer_empty() const { return buffer.size() == 0; }

bool ByteStream::eof() const { return inputEndFlag && buffer.size() == 0; }

size_t ByteStream::bytes_written() const { return totalWrite; }

size_t ByteStream::bytes_read() const { return totalRead; }

size_t ByteStream::remaining_capacity() const { return capacity - buffer.size(); }
