package waffleLib

import "base:runtime"

append_doubling :: proc(
	array: ^$T/[dynamic]$E,
	arg: E,
	allocator := context.allocator,
) -> (
	n: int,
	err: runtime.Allocator_Error,
) {
	if len(array) >= cap(array) {
		reserve(array, cap(array) * 2) or_return
	}

	return append(array, arg)
}
