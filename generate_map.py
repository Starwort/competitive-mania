import re
import struct

FLAG_DIRLEFT = 0b0000_1000
FLAG_DIRDOWN = 0b0000_0100
FLAG_DIR__UP = 0b0000_0010
FLAG_DIRRGHT = 0b0000_0001
FLAG_SONGEND = 0b1000_0000


def pack(up: bool, left: bool, right: bool, down: bool, end: bool, time: int) -> bytes:
    return struct.pack(
        "<IB",
        time,
        up * FLAG_DIR__UP
        | left * FLAG_DIRLEFT
        | right * FLAG_DIRDOWN
        | down * FLAG_DIRDOWN
        | end * FLAG_SONGEND,
    )


OBJECT = re.compile(r"(\d+) (L?)(D?)(U?)(R?)(;?)")


def generate_map(in_file: str, out_file: str) -> None:
    with open(in_file) as file, open(out_file, "wb") as map:
        for line in file:
            time, l, d, u, r, e = OBJECT.match(line).groups()
            map.write(pack(bool(u), bool(l), bool(r), bool(d), bool(e), int(time)))
