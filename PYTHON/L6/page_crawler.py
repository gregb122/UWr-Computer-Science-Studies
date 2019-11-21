import typing
from time import time
import bs4
import requests
import re


class Crawler:
    """
    Web Crawler for processing http/https pages using predefined user actions.
    """
    def __init__(self):
        self.soup = None
        self.visited_pages = set()
        self.page_text = ""

    def crawl(self, start_page: str, distance: int,
              action: str) -> typing.Generator[typing.Tuple[str, typing.List[str]], None, None]:
        """
        Process web pages in DFS order:
        1. Start from start_page and perform action
        2. Visit all links of this page (call this function recursively with distance - 1)
        3. Perform an action for each visited page
        4. Repeat until distance > 0
        :param start_page:      Starting point of crawling, root page.
        :param distance:        Maximum recursion depth of crawl
        :param action:          Predefined user action
        :return:                Generator which single step is a URL of visited page and action result
        """
        if distance == 0:
            return
        if start_page not in self.visited_pages:
            if start_page.startswith('http'):
                page = requests.get(start_page)
                self.soup = bs4.BeautifulSoup(page.content, 'html.parser')

                expr_result = eval(f"self.{action}")

                self.visited_pages.add(start_page)
                yield start_page, expr_result

                for link in self.soup.find_all('a'):
                    yield from self.crawl(link.get('href'), distance - 1, action)

    def find_sentences_with_word(self, word: str) -> typing.List[str]:
        """
        Extract sentences containing :param word from parsed html page (called as 'soup').
        Remove all sentences placed in non-body specific html tags.
        :return:        Sentences which contain :param word
        """
        for element in self.soup(["script", "style", "head"]):
            element.decompose()
        return [sentence.strip(' ') for sentence in re.split(r"[\n*|\.]", self.soup.get_text()) if word in sentence]


crawler = Crawler()
start = time()
for crawl_result in crawler.crawl("https://www.python.org/", 2, "find_sentences_with_word('Python')"):
    print(crawl_result)
end = time()
print(f"TOTAL EXECUTION TIME: {round(end - start, 4)}")
