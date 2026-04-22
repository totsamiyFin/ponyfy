#include "utils.h"

#include <flutter_windows.h>
#include <io.h>
#include <stdio.h>
#include <windows.h>

#include <iostream>

std::string GetExecutableName() {
  char buffer[MAX_PATH];
  GetModuleFileNameA(nullptr, buffer, MAX_PATH);
  std::string full_path(buffer);
  return full_path.substr(full_path.find_last_of("/\\") + 1);
}

std::vector<std::string> GetCommandLineArguments() {
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr) {
    return {};
  }

  std::vector<std::string> command_line_arguments;
  for (int i = 1; i < argc; i++) {
    command_line_arguments.push_back(
        std::string(argv[i], argv[i] + wcslen(argv[i])));
  }

  LocalFree(argv);
  return command_line_arguments;
}
