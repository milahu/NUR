#include <curl/curl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(
        stderr,
        "Usage: kagi \"search query\" [--cli browser] [--brave \"query\"]\n");
    return 1;
  }

  CURL *curl = curl_easy_init();
  if (!curl) {
    fprintf(stderr, "Error initializing curl\n");
    return 1;
  }

  char *escaped_query = curl_easy_escape(curl, argv[1], 0);
  if (!escaped_query) {
    fprintf(stderr, "Error escaping the query\n");
    curl_easy_cleanup(curl);
    return 1;
  }

  const char defaultUrl[] = "https://kagi.com/search?q=";
  const char altUrl[] = "https://search.brave.com/search?q=";
  const char *selectedUrl = defaultUrl;

  char *cli_browser = NULL;

  if (strcmp(argv[1], "--help") == 0) {
    printf("kagi: A simple CLI tool for making web searches\n\n"
           "Usage:\n"
           "  kagi \"search query\" [--cli browser] [--brave] [--help]\n\n"
           "Options:\n"
           "  --cli browser   Opens search results in a specified CLI browser "
           "such as 'lynx', 'w3m', or 'links'. Replace 'browser' with the "
           "desired CLI browser name.\n"
           "  --brave       Uses an alternative search base URL (Brave search) "
           "instead of the default Kagi base URL.\n"
           "  --help          Shows this help text.\n\n"
           "Examples:\n"
           "  kagi \"hello world\"\n"
           "  kagi \"hello world\" --cli lynx\n"
           "  kagi \"hello world\" --brave\n"
           "  kagi \"hello world\" --cli w3m --brave\n\n"
           "Note: By default, the program uses 'xdg-open' in Linux systems or "
           "'open' in macOS systems to open search results in the default web "
           "browser.\n");
    return 0;
  }

  for (int i = 2; i < argc; i++) {
    if (strcmp(argv[i], "--cli") == 0 && i + 1 < argc) {
      cli_browser = argv[i + 1];
      i++;
    } else if (strcmp(argv[i], "--brave") == 0) {
      selectedUrl = altUrl;
    } else {
      fprintf(stderr, "Unknown argument: %s\n", argv[i]);
      return 1;
    }
  }

  char url[512];
  snprintf(url, sizeof(url), "%s%s", selectedUrl, escaped_query);

  printf("Opening URL: %s\n", url);

  char cmd[1024];
  if (cli_browser) {
    snprintf(cmd, sizeof(cmd), "%s \"%s\"", cli_browser, url);
  } else {
    // Replace 'xdg-open' with 'open' for macOS
    snprintf(cmd, sizeof(cmd), "xdg-open \"%s\"", url);
  }

  int result = system(cmd);
  curl_free(escaped_query);
  curl_easy_cleanup(curl);

  if (result) {
    fprintf(stderr, "Error opening the URL\n");
    return 1;
  }

  return 0;
}
