#ifndef __ASSERT__
#define __ASSERT__

#include <string>
#include <sstream>
#include <iostream>

// Assert with exception
#define assert_msg(expr, msg) 		                                  \
    {                                                                     \
        if (!(expr))                                                      \
        {                                                                 \
            std::cout << msg << std::endl;                                \
            assert(false);                                                \
        }                                                                 \
    }

#define assert_nomsg(expr)	                                                  \
    {                                                                     \
        if (!(expr))                                                      \
        {                                                                 \
            assert(false);                                                \
        }                                                                 \
    }

#endif
