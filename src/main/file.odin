package sudoku

import "core:fmt"
import "core:os"
import "core:strings"

fileRead_Error :: union {
	os.Errno,
	bool,
}

read_sudoku_file :: proc(path: string) -> (puzzleSet: [dynamic]SudokuPuzzle, err: fileRead_Error) {
	data := os.read_entire_file(path, context.allocator) or_return
	defer delete(data, context.allocator)

	filePuzzles := make([dynamic]SudokuPuzzle, 0, 100)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		if len(line) < 81 do continue

		p, err := parse_sudoku_line(line[0:81])
		if err == ParseError.None do append(&filePuzzles, p)
	}

	return filePuzzles, err
}

ParseError :: enum {
	None,
	UnexpectedChar,
	StringTooShort,
}

parse_sudoku_line :: proc(inputLine: string) -> (out: SudokuPuzzle, err: ParseError) {
	if len(inputLine) < 81 do return {}, ParseError.StringTooShort

	for c, i in inputLine {
		switch c {
		case '.':
			out[i / 9][i % 9] = CellPossibilities{1, 2, 3, 4, 5, 6, 7, 8, 9}
		case '1' ..= '9':
			out[i / 9][i % 9] = cast(u16)c - '0'
		case:
			return out, ParseError.UnexpectedChar
		}
	}
	return out, ParseError.None
}
