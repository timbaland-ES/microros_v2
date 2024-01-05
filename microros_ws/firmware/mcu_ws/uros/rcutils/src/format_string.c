// Copyright 2017 Open Source Robotics Foundation, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifdef __cplusplus
extern "C"
{
#endif

#include "rcutils/format_string.h"

#include <stdarg.h>
#include <stddef.h>
#ifdef _WIN32
#include <stdio.h>
#endif
#include <string.h>

#include "rcutils/snprintf.h"

//BittlT: dynamic allocation replaced
char output_string_first_global[100];
char output_string_sec_global[100];
char output_string_third_global[100];
int output_string_global_counterCheck = 0;

char *
rcutils_format_string_limit(
  rcutils_allocator_t allocator,
  size_t limit,
  const char * format_string,
  ...)
{
  if (NULL == format_string) {
    return NULL;
  }
  RCUTILS_CHECK_ALLOCATOR(&allocator, return NULL);
  // extract the variadic arguments twice, once for length calculatio and once for formatting.
  va_list args1;
  va_start(args1, format_string);
  va_list args2;
  va_copy(args2, args1);
  // first calculate the output string
  size_t bytes_to_be_written = (size_t)rcutils_vsnprintf(NULL, 0, format_string, args1);
  va_end(args1);
  if (bytes_to_be_written == (size_t)-1) {
    va_end(args2);
    return NULL;
  }
  // allocate space for the return string
  if (bytes_to_be_written + 1 > limit) {
    bytes_to_be_written = limit - 1;
  }

  //BittlT: dynamic allocation replaced
  //char * output_string = allocator.allocate(bytes_to_be_written + 1, allocator.state);

  char * output_string = NULL;
  if (output_string_global_counterCheck == 0){
        output_string = output_string_first_global;
        output_string_global_counterCheck++;
        }
    else if (output_string_global_counterCheck == 1){
        output_string = output_string_sec_global;
        output_string_global_counterCheck++;
        }
    else if (output_string_global_counterCheck == 2){
        output_string = output_string_third_global;
        output_string_global_counterCheck++;
        }
    else return 0; //== FALSE

  if (NULL == output_string) {
    va_end(args2);
    return NULL;
  }
  // format the string
  int ret = rcutils_vsnprintf(output_string, bytes_to_be_written + 1, format_string, args2);
  if (0 > ret) {
    //BittlT: no dynamic allocation
    //allocator.deallocate(output_string, allocator.state);
    va_end(args2);
    return NULL;
  }
  output_string[bytes_to_be_written] = '\0';
  va_end(args2);
  return output_string;
}

#ifdef __cplusplus
}
#endif
