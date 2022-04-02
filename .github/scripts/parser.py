import re


def main():
    with open('../../test_log.txt') as f:
        lines = list(filter(bool, f.read().splitlines()))

    passed = re.findall(r'^(\d+)%', lines[-2])[0]

    if passed != 100:
        exit(1)


if __name__ == '__main__':
    main()
