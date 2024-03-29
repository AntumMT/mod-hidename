## Hide Name

### Description:

A [Minetest](http://www.minetest.net/) mod that allows players to hide their nametags from view.

### Usage:

##### Chat commands:

```
- /nametag [command]
  - commands:
	  - hide:   sets nametag hidden
    - show:   sets nametag visible
    - status: prints the visible/hidden state of nametag (default)

- /hidename
  - alias for `/nametag hide`

- /showname
  - alias for `/nametag show`
```

##### Settings:

```
- hidename.use_alpha
  - use alpha color level to hide nametag instead of clearing text
  - type:    bool
  - default: false
```

### Licensing:

- [MIT](LICENSE.txt)

### Requirements:

```
Dependencies:
- Required: none
- Optional: invisibility, invisible

Privileges:
- Required: none
```

### Links:

- [![ContentDB](https://content.minetest.net/packages/AntumDeluge/hidename/shields/title/)](https://content.minetest.net/AntumDeluge/hidename/)
- [Forum](https://forum.minetest.net/viewtopic.php?t=18190)
- [Git repo](https://github.com/AntumMT/mod-hidename)
- [Reference](http://antummt.github.io/mod-hidename/reference/current/)
- [Changelog](changelog.txt)
- [TODO](TODO.txt)
