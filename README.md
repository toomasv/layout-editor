# layout-editor
Live layout editor

Initial version. Unstable and buggy.

(Pallette is https://raw.githubusercontent.com/toomasv/diager/master/pallette.red)

## Usage:

Simple initial window:
```
live-edit
```

With initial layout, e.g.:
```
live-edit/source [size 400x400 text "Try it:" 30x25 field 270x25 button "Clear" return box white 380x340]
```

With saved initial layout (saved earlier from live-edit session):
```
live-edit/source %tmp-lay.red
```
