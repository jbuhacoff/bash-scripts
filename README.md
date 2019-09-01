---
title: Scripts
---

This repository contains scripts that are generally useful to have around and are not
application-specific.

Guidelines for scripts:

* take paths as parameters; do not assume the script install location
* be independent; do not rely on other scripts in the collection

# How to use with run-script

When using `rs` and `w`, the `path/append` and `path/insert` scripts are especially
useful for adding script locations based on workspace settings.

The easiest way to make sure `path/*` scripts are in `RS_PATH` is to initialize
`RS_PATH` in your login setup scripts like this:

``` bash
mkdir -p /etc/profile.d
cat >/etc/profile.d/rs_path.sh <<EOF
#!/bin/sh
export RS_PATH=~/script:/path/to/jbuhacoff/bash-scripts
EOF
```

Or you can check for a `path/*` script already in `RS_PATH` and conditionally add
the location anytime like this:

``` bash
if ! rs -l path/append 2>/dev/null; then
  if [ -z "$RS_PATH" ]; then
    export RS_PATH=/path/to/jbuhacoff/bash-scripts
  else
    export RS_PATH=$RS_PATH:/path/to/jbuhacoff/bash-scripts
  fi
fi
```

In other scripts you can conditionally use `path/append` like this:

``` bash
if rs -l path/append >/dev/null; then
  export RS_PATH=$(rs path/append RS_PATH /path/to/more/scripts)
fi
```

The above example will either add `/path/to/more/scripts` to `RS_PATH` or
print `error: script not found: path/append` to stderr (output of `rs -l <script>`
when it is not found).

# Path

Path-manipulation scripts: append, insert

