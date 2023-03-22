import urllib.request
import sys

def check_website_status():
    while True:
        url = sys.argv[1]
        if url.startswith('https://'):
            pass
        elif url.startswith('http://'):
            pass
        else:
            url = 'https://' + url
        try:
            # tries to make a request to the URL that was input
            # uses defined headers that are not a "bot"
            headers = {}
            headers['User-Agent'] = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 \
            (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36")
            req = urllib.request.Request(url, headers=headers)
            page = urllib.request.urlopen(req)
            code = str(page.getcode())
            print('The website ' + url + ' has returned a ' + code + ' code')
            break
        except Exception as e:
            print("CRITICAL:HOST SEEMS OFFLINE/NOT-REACHABLE--->"+url)
            break
check_website_status()
sys.exit(2)
