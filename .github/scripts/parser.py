import re


def main():
    with open('test_log.txt') as f:
        lines = list(filter(bool, f.read().splitlines()))

    passed = re.findall(r'^(\d+)%', lines[-2])[0]
    print(f'{passed}% passed')

    if passed != '100':
        print('Test failed')
        exit(1)

    print('All tests passed!')


if __name__ == '__main__':
    main()
