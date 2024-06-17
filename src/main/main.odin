package sudoku

import "core:fmt"

main :: proc() {
	//puzzles, err := read_sudoku_file("./test-files/test-puzzles01")
	//for puz in puzzles {fmt.print(format_puzzle_str(puz))}
	return
}

Cell :: union {
	u16,
	CellPossibilities,
}

CellPossibilities :: bit_set[1 ..= 9]

SudokuPuzzle :: [9][9]Cell

Address_Rows :: proc(indexGrp: u16, indexCell: u16) -> (x: u16, y: u16, ok: bool) {
	if (indexGrp > 8) || (indexCell > 8) do return 0, 0, false
	return indexGrp, indexCell, true
}

Address_Cols :: proc(indexGrp: u16, indexCell: u16) -> (x: u16, y: u16, ok: bool) {
	if (indexGrp > 8) || (indexCell > 8) do return 0, 0, false
	return indexCell, indexGrp, true
}

Address_Sqrs :: proc(indexGrp: u16, indexCell: u16) -> (x: u16, y: u16, ok: bool) {
	if (indexGrp > 8) || (indexCell > 8) do return 0, 0, false
	switch indexGrp {
	case 0 ..= 2:
		switch indexCell {
		case 0 ..= 2:
			x = 0
		case 3 ..= 5:
			x = 1
		case 6 ..= 8:
			x = 2
		}
	case 3 ..= 5:
		switch indexCell {
		case 0 ..= 2:
			x = 3
		case 3 ..= 5:
			x = 4
		case 6 ..= 8:
			x = 5
		}
	case 6 ..= 8:
		switch indexCell {
		case 0 ..= 2:
			x = 6
		case 3 ..= 5:
			x = 7
		case 6 ..= 8:
			x = 8
		}
	}

	switch indexGrp {
	case 0, 3, 6:
		switch indexCell {
		case 0, 3, 6:
			y = 0
		case 1, 4, 7:
			y = 1
		case 2, 5, 8:
			y = 2
		}
	case 1, 4, 7:
		switch indexCell {
		case 0, 3, 6:
			y = 3
		case 1, 4, 7:
			y = 4
		case 2, 5, 8:
			y = 5
		}
	case 2, 5, 8:
		switch indexCell {
		case 0, 3, 6:
			y = 6
		case 1, 4, 7:
			y = 7
		case 2, 5, 8:
			y = 8
		}
	}
	return x, y, true
}

Address_All :: proc(indexGrp: u16, indexCell: u16) -> (x: u16, y: u16, ok: bool) {
	ig: u16 = indexGrp % 9
	switch indexGrp {
	case 0 ..< 9:
		return Address_Rows(cast(u16)indexGrp, indexCell)
	case 9 ..< 18:
		return Address_Cols(ig, indexCell)
	case 18 ..< 27:
		return Address_Sqrs(ig, indexCell)
	case:
		return 0, 0, false
	}
}

LogicResult :: struct {
	changedCells: bool,
}
