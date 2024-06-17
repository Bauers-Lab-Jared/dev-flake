package sudoku

import "core:fmt"
import "core:io"
import "core:strconv"
import "core:strings"

Format_Error :: enum {
	None,
}

Puzzle_Format_Error :: union {
	Format_Error,
	io.Error,
}

format_puzzle_str :: proc(p: SudokuPuzzle) -> (puzzleString: string, err: Puzzle_Format_Error) {
	using strings

	puzzleStringTemplate := `
     . . . | . . . | . . .
     . . . | . . . | . . .
     . . . | . . . | . . .
    -------|-------|-------
     . . . | . . . | . . .
     . . . | . . . | . . .
     . . . | . . . | . . .
    -------|-------|-------
     . . . | . . . | . . .
     . . . | . . . | . . .
     . . . | . . . | . . .
    `

	reader: Reader
	reader_init(&reader, puzzleStringTemplate)
	assert(reader_length(&reader) >= 81, "Puzzle template length too short")

	builder: Builder
	builder_init_len(&builder, len(puzzleStringTemplate))

	for r in 0 ..< 9 {
		for c in 0 ..< 9 {
			done := false
			for !done {
				read := reader_read_byte(&reader) or_return

				if read == '.' {

					switch v in p[r][c] {
					case u16:
						switch v {
						case 1 ..= 9:
							buf: [4]byte
							write_string(&builder, strconv.itoa(buf[:], cast(int)(0 + v)))
							done = true
						case:
							write_byte(&builder, read)
							done = true
						}
					case CellPossibilities:
						write_byte(&builder, read)
						done = true
					}
				} else {
					write_byte(&builder, read)
				}
			}
		}
	}

	for {
		read, e := reader_read_byte(&reader)
		if e == io.Error.EOF do break
		write_byte(&builder, read)
	}

	puzzleString = to_string(builder)
	return puzzleString, Format_Error.None
}
