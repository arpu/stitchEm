if(COMPILER_CLANG)
  find_program(IWYU NAMES include-what-you-use iwyu)
  if(IWYU)
    set(HAVE_IWYU TRUE) 
  endif()
endif()