// Copyright 2024 N-GINN LLC. All rights reserved.
// Use of this source code is governed by a BSD-3 Clause license that can be found in the LICENSE file.


#include "helpers/buffer_test_utils.h"

using namespace testing;

namespace nau::test
{

    void fillBufferWithDefaultContent(BytesBuffer& buffer, size_t offset, std::optional<size_t> size)
    {
        const size_t fillSize = !size ? (buffer.size() - offset) : *size;

        NAU_VERIFY(offset + fillSize <= buffer.size());

        uint8_t* const charPtr = reinterpret_cast<uint8_t*>(buffer.data());

        for(size_t i = offset; i < fillSize; ++i)
        {
            charPtr[i] = static_cast<uint8_t>(i % std::numeric_limits<uint8_t>::max());
        }
    }

    BytesBuffer createBufferWithDefaultContent(size_t size)
    {
        BytesBuffer buffer(size);
        fillBufferWithDefaultContent(buffer);

        return buffer;
    }

    AssertionResult buffersEqual(const BufferView& buffer1, const BufferView& buffer2)
    {
        if(buffer1.size() != buffer2.size())
        {
            return AssertionFailure() << "Buffer size mismatch: " << buffer1.size() << " bytes != " << buffer2.size() << " bytes";
        }

        const std::byte* const data1 = buffer1.data();
        const std::byte* const data2 = buffer2.data();
        for(size_t i = 0, size = buffer1.size(); i < size; ++i)
        {
            if(data1[i] != data2[i])
            {
                return AssertionFailure() << "Buffer content mismatch at [" << i << "]";
            }
        }

        return AssertionSuccess();
    }

}  // namespace nau::test