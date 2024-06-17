package sudoku

import "core:fmt"
import "core:testing"

@(test)
Test_Address_Rows :: proc(t: ^testing.T) {
	for ig in 0 ..= 9 {
		for ic in 0 ..= 9 {
			outOfBounds := ((ig >= 9) || (ic >= 9))
			expected1, expected2: u16
			if outOfBounds {
				expected1, expected2 = 0, 0
			} else {
				expected1, expected2 = cast(u16)ig, cast(u16)ic
			}

			actual1, actual2, ok := Address_Rows(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2) && (ok || outOfBounds),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}
}

@(test)
Test_Address_Cols :: proc(t: ^testing.T) {
	for ig in 0 ..= 9 {
		for ic in 0 ..= 9 {
			outOfBounds := ((ig >= 9) || (ic >= 9))
			expected1, expected2: u16
			if outOfBounds {
				expected1, expected2 = 0, 0
			} else {
				expected1, expected2 = cast(u16)ic, cast(u16)ig
			}

			actual1, actual2, ok := Address_Cols(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2) && (ok || (!ok && outOfBounds)),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}
}

@(test)
Test_Address_Sqrs :: proc(t: ^testing.T) {
	lut: [9][9][2]u16 = {
		{{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}},
		{{0, 3}, {0, 4}, {0, 5}, {1, 3}, {1, 4}, {1, 5}, {2, 3}, {2, 4}, {2, 5}},
		{{0, 6}, {0, 7}, {0, 8}, {1, 6}, {1, 7}, {1, 8}, {2, 6}, {2, 7}, {2, 8}},
		{{3, 0}, {3, 1}, {3, 2}, {4, 0}, {4, 1}, {4, 2}, {5, 0}, {5, 1}, {5, 2}},
		{{3, 3}, {3, 4}, {3, 5}, {4, 3}, {4, 4}, {4, 5}, {5, 3}, {5, 4}, {5, 5}},
		{{3, 6}, {3, 7}, {3, 8}, {4, 6}, {4, 7}, {4, 8}, {5, 6}, {5, 7}, {5, 8}},
		{{6, 0}, {6, 1}, {6, 2}, {7, 0}, {7, 1}, {7, 2}, {8, 0}, {8, 1}, {8, 2}},
		{{6, 3}, {6, 4}, {6, 5}, {7, 3}, {7, 4}, {7, 5}, {8, 3}, {8, 4}, {8, 5}},
		{{6, 6}, {6, 7}, {6, 8}, {7, 6}, {7, 7}, {7, 8}, {8, 6}, {8, 7}, {8, 8}},
	}

	for ig in 0 ..= 9 {
		for ic in 0 ..= 9 {
			outOfBounds := ((ig >= 9) || (ic >= 9))
			expected1, expected2: u16
			if outOfBounds {
				expected1, expected2 = 0, 0
			} else {
				expected1, expected2 = lut[ig][ic][0], lut[ig][ic][1]
			}

			actual1, actual2, ok := Address_Sqrs(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2) && (ok || outOfBounds),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}
}

@(test)
Test_Address_All :: proc(t: ^testing.T) {
	lut: [9][9][2]u16 = {
		{{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}, {2, 0}, {2, 1}, {2, 2}},
		{{0, 3}, {0, 4}, {0, 5}, {1, 3}, {1, 4}, {1, 5}, {2, 3}, {2, 4}, {2, 5}},
		{{0, 6}, {0, 7}, {0, 8}, {1, 6}, {1, 7}, {1, 8}, {2, 6}, {2, 7}, {2, 8}},
		{{3, 0}, {3, 1}, {3, 2}, {4, 0}, {4, 1}, {4, 2}, {5, 0}, {5, 1}, {5, 2}},
		{{3, 3}, {3, 4}, {3, 5}, {4, 3}, {4, 4}, {4, 5}, {5, 3}, {5, 4}, {5, 5}},
		{{3, 6}, {3, 7}, {3, 8}, {4, 6}, {4, 7}, {4, 8}, {5, 6}, {5, 7}, {5, 8}},
		{{6, 0}, {6, 1}, {6, 2}, {7, 0}, {7, 1}, {7, 2}, {8, 0}, {8, 1}, {8, 2}},
		{{6, 3}, {6, 4}, {6, 5}, {7, 3}, {7, 4}, {7, 5}, {8, 3}, {8, 4}, {8, 5}},
		{{6, 6}, {6, 7}, {6, 8}, {7, 6}, {7, 7}, {7, 8}, {8, 6}, {8, 7}, {8, 8}},
	}

	for ig in 0 ..< 9 {
		for ic in 0 ..< 9 {
			expected1, expected2 := cast(u16)ig, cast(u16)ic
			actual1, actual2, _ := Address_All(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}

	for ig in 9 ..< 18 {
		for ic in 0 ..< 9 {
			expected1, expected2 := cast(u16)ic, cast(u16)(ig - 9)
			actual1, actual2, _ := Address_All(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}

	for ig in 18 ..< 27 {
		for ic in 0 ..< 9 {
			expected1, expected2 := lut[ig % 9][ic][0], lut[ig % 9][ic][1]
			actual1, actual2, _ := Address_All(cast(u16)ig, cast(u16)ic)
			testing.expect(
				t,
				(expected1 == actual1) && (expected2 == actual2),
				fmt.tprintf(
					"With [%v][%v] input, expected [%v][%v], got [%v][%v]",
					ig,
					ic,
					expected1,
					expected2,
					actual1,
					actual2,
				),
			)
		}
	}
}

@(test)
Test_Check_Solved_Cells :: proc(t: ^testing.T = {}) {
	testPuzzle: SudokuPuzzle

	shifty: u16
	for row, r in testPuzzle {
		if r > 0 do shifty += transmute(u16)CellPossibilities{r}
		for cell, i in row {
			testPuzzle[r][i] = transmute(CellPossibilities)(shifty << cast(u16)i)
			fmt.printf("[%v][%v]", r, i)
			for p in testPuzzle[r][i].(CellPossibilities) {
				fmt.printf(", %v", p)
			}
			fmt.println("")
		}
	}

	//Check_Solved_Cells(&testPuzzle)

	for i in 0 ..< 9 {
		testPuzzle[0][i] = Cell{}
	}

	return
}
