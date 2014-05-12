#!/usr/bin/env python
InsertVariable {
	FindName {	} FindName OK, ((nil)) 
	FindName {	} FindName OK, (0x11e70e0) 
} InsertVariable OK
PrintTable {
	Posicao 0 (0x11e70e0):
	type = int
	name = a
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = (nil)

} PrintTable 
InsertVariable {
	FindName {	} FindName OK, ((nil)) 
	FindName {	} FindName OK, (0x11e7140) 
} InsertVariable OK
PrintTable {
	Posicao 0 (0x11e7140):
	type = int
	name = b
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = 0x11e70e0

	Posicao 1 (0x11e70e0):
	type = int
	name = a
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = (nil)

} PrintTable 
InsertVariable {
	FindName {	} FindName OK, ((nil)) 
	FindName {	} FindName OK, (0x11e71c0) 
} InsertVariable OK
int = c
PrintTable {
	Posicao 0 (0x11e71c0):
	type = int
	name = c
	returnedValue = (null)
	scope = 1
	value = 10
	prev = 0x11e7140

	Posicao 1 (0x11e7140):
	type = int
	name = b
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = 0x11e70e0

	Posicao 2 (0x11e70e0):
	type = int
	name = a
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = (nil)

} PrintTable 
	FindName {	} FindName OK, (0x11e70e0) 
a = 5
PrintTable {
	Posicao 0 (0x11e71c0):
	type = int
	name = c
	returnedValue = (null)
	scope = 1
	value = 10
	prev = 0x11e7140

	Posicao 1 (0x11e7140):
	type = int
	name = b
	returnedValue = (null)
	scope = 1
	value = (null)
	prev = 0x11e70e0

	Posicao 2 (0x11e70e0):
	type = int
	name = a
	returnedValue = (null)
	scope = 1
	value = 5
	prev = (nil)

} PrintTable 
