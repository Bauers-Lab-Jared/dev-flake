package project

import "core:fmt"
import waffle "lib:waffle"
import rl "vendor:raylib"

main :: proc() {
	fmt.println("Sup.")

	//fmt.println(waffle.is_inside_rectangle({3.0, 1.0}, {0.0, 0.0}, {2.0, 2.0}))
	rl.InitWindow(800, 800, "raylib test")
	rl.SetTargetFPS(60)
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.EndDrawing()
	}
}
