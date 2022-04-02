import re


def main():
    with open('test_log.txt') as f:
        lines = f.read()

    passed = re.findall(r'^(\d*)%.*$', lines, flags=re.MULTILINE)[0]
    print(f'{passed}% passed')

    if passed != '100':
        print('Test failed')
        exit(1)

    print('All tests passed!')


if __name__ == '__main__':
    main()
