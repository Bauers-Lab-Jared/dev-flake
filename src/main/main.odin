package project

import "core:fmt"
import waffle "waffle:lib"

main :: proc() {
	fmt.println("Sup.")

	fmt.println(waffle.is_inside_rectangle({3.0, 1.0}, {0.0, 0.0}, {2.0, 2.0}))
}
