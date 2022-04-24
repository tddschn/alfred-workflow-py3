
<div align="center">
  <img src="./icon.png" alt="alfred-workflow-tddschn logo" height="200">
</div>

Note: this is a fork of the amazing [https://github.com/deanishe/alfred-workflow][repo] and has some differences. 

alfred-workflow-tddschn
===============

A helper library in Python for authors of workflows for [Alfred 3 and 4][alfred].

<!-- [![Build Status][shield-travis]][travis] -->
[![Build Status][shield-github]][action-github]
[![Coverage Status][shield-coveralls]][coveralls]
[![Development Status][shield-status]][pypi]
[![Latest Version][shield-version]][pypi]
[![Supported Python Versions][shield-pyversions]][pypi]

<!-- [![Downloads][shield-download]][pypi] -->

Supports Alfred 3 and Alfred 4 on macOS 10.7+ (Python 3.7+).

alfred-workflow-tddschn takes the grunt work out of writing a workflow by giving you the tools to create a fast and featureful Alfred workflow from an API, application or library in minutes.

Always supports all current Alfred features.


Features
--------

- Auto-saved settings API for your workflow
- Super-simple data caching with expiry
- Fuzzy filtering (with smart diacritic folding)
- Keychain support for secure storage of passwords, API keys etc.
- Background tasks to keep your workflow responsive
- Simple generation of Alfred JSON feedback
- Full support of Alfred's AppleScript/JXA API
- Catches and logs workflow errors for easier development and support
- "Magic" arguments to help development/debugging
- Unicode support
- Pre-configured logging
- Automatically check for workflow updates via GitHub releases
- Post notifications via Notification Center


### Alfred 4+ features ###

- Advanced modifiers
- Alfred 4-only updates (won't break older Alfred installs)


Contents
--------


- [alfred-workflow-tddschn](#alfred-workflow-tddschn)
  - [Features](#features)
    - [Alfred 4+ features](#alfred-4-features)
  - [Contents](#contents)
  - [Installation](#installation)
    - [With pip](#with-pip)
    - [From source](#from-source)
  - [Usage](#usage)
    - [Workflow script skeleton](#workflow-script-skeleton)
    - [Examples](#examples)
      - [Keychain access](#keychain-access)
  - [Documentation](#documentation)
    - [Dash docset](#dash-docset)
  - [Licensing, thanks](#licensing-thanks)
  - [Contributing](#contributing)
    - [Adding a workflow to the list](#adding-a-workflow-to-the-list)
    - [Bug reports, pull requests](#bug-reports-pull-requests)
    - [Contributors](#contributors)
  - [Workflows using alfred-workflow-tddschn](#workflows-using-alfred-workflow-tddschn)



<a name="installation"></a>
Installation
------------

**Note**: If you're new to Alfred workflows, check out
[the tutorial][docs-tutorial] in the docs.


<a name="with-pip"></a>
### With pip ###

You can install alfred-workflow-tddschn directly into your workflow with:

```bash
# from your workflow directory
pip install --target=. alfred-workflow-tddschn
```

You can install any other library available on the [Cheese Shop][cheeseshop] the same way. See the [pip documentation][pip-docs] for more information.

It is highly advisable to bundle all your workflow's dependencies with your workflow in this way. That way, it will "just work".


<a name="from-source"></a>
### From source ###

1. Download the `alfred-workflow-X.X.X.zip` from the [GitHub releases page][releases].
2. Extract the ZIP archive and place the `workflow` directory in the root folder of your workflow (where `info.plist` is).

Your workflow should look something like this:

    Your Workflow/
        info.plist
        icon.png
        workflow/
            __init__.py
            background.py
            notify.py
            Notify.tgz
            update.py
            version
            workflow.py
        yourscript.py
        etc.

Alternatively, you can clone/download the alfred-workflow-tddschn [repository][repo] and copy the `workflow` subdirectory to your workflow's root directory.


<a name="usage"></a>
Usage
-----

A few examples of how to use alfred-workflow-tddschn.


<a name="workflow-script-skeleton"></a>
### Workflow script skeleton ###

Set up your workflow scripts as follows (if you wish to use the built-in error handling or `sys.path` modification):

```python
#!/usr/bin/python
# encoding: utf-8

import sys

# Workflow3 supports Alfred 3's new features. The `Workflow` class
# is also compatible with Alfred 2.
from workflow import Workflow3


def main(wf):
    # The Workflow3 instance will be passed to the function
    # you call from `Workflow3.run`.
    # Not super useful, as the `wf` object created in
    # the `if __name__ ...` clause below is global...
    #
    # Your imports go here if you want to catch import errors, which
    # is not a bad idea, or if the modules/packages are in a directory
    # added via `Workflow3(libraries=...)`
    import somemodule
    import anothermodule

    # Get args from Workflow3, already in normalized Unicode.
    # This is also necessary for "magic" arguments to work.
    args = wf.args

    # Do stuff here ...

    # Add an item to Alfred feedback
    wf.add_item(u'Item title', u'Item subtitle')

    # Send output to Alfred. You can only call this once.
    # Well, you *can* call it multiple times, but subsequent calls
    # are ignored (otherwise the JSON sent to Alfred would be invalid).
    wf.send_feedback()


if __name__ == '__main__':
    # Create a global `Workflow3` object
    wf = Workflow3()
    # Call your entry function via `Workflow3.run()` to enable its
    # helper functions, like exception catching, ARGV normalization,
    # magic arguments etc.
    sys.exit(wf.run(main))
```


<a name="examples"></a>
### Examples ###

Cache data for 30 seconds:

```python
def get_web_data():
    import json
    from urllib import request
    with request.urlopen('http://www.example.com') as f:
      data = f.read().decode('utf-8')
    return json.loads(data)

def main(wf):
    # Save data from `get_web_data` for 30 seconds under
    # the key ``example``
    data = wf.cached_data('example', get_web_data, max_age=30)
    for datum in data:
        wf.add_item(datum['title'], datum['author'])

    wf.send_feedback()
```

<a name="keychain-access"></a>
#### Keychain access ####

Save password:

```python
wf = Workflow()
wf.save_password('name of account', 'password1lolz')
```

Retrieve password:

```python
wf = Workflow()
wf.get_password('name of account')
```


<a name="documentation"></a>
Documentation
-------------

The full documentation, including API docs and a tutorial, can be found at [deanishe.net][docs].


<a name="dash-docset"></a>
### Dash docset ###

The documentation is also available as a [Dash docset][dash].


<a name="licensing-thanks"></a>
Licensing, thanks
-----------------

The code and the documentation are released under the MIT and [Creative Commons Attribution-NonCommercial][cc] Licenses respectively. See [License.txt](License.txt) for details.

The documentation was generated using [Sphinx][sphinx] and a modified version of the [Alabaster][alabaster] theme by [bitprophet][bitprophet].

Many of the cooler ideas in alfred-workflow-tddschn were inspired by [Alfred2-Ruby-Template][ruby-template] by Zhaocai.

The Keychain parser was based on [Python-Keyring][python-keyring] by Jason R. Coombs.


<a name="contributing"></a>
Contributing
------------


<a name="adding-a-workflow-to-the-list"></a>
### Adding a workflow to the list ###

If you want to add a workflow to the [list of workflows using alfred-workflow-tddschn][docs-workflows], **don't add it to the docs!** The list is machine-generated from [Packal.org][packal] and the [`library_workflows.tsv`](extras/library_workflows.tsv) file. If your workflow is available on [Packal][packal], it will be added on the next update. If not, please add it to [`library_workflows.tsv`](extras/library_workflows.tsv), and submit a corresponding pull request.

The list is not auto-updated, so if you've released a workflow and are keen to see it in this list, please [open an issue][issues] asking me to update the list.


<a name="bug-reports-pull-requests"></a>
### Bug reports, pull requests ###

Please see [the documentation][docs-contributing].


<a name="contributors"></a>
### Contributors ###

- [Dean Jackson][deanishe]
- [Stephen Margheim][smargh]
- [Fabio Niephaus][fniephaus]
- [Owen Min][owenwater]


<a name="workflows-using-alfred-workflow"></a>
Workflows using alfred-workflow-tddschn
-------------------------------

[Here is a list][docs-workflows] of some of the many workflows based on alfred-workflow-tddschn.


[alfred]: http://www.alfredapp.com/
[alfred-workflow-scaffold]: https://github.com/NorthIsUp/alfred-workflow-scaffold
[awv2]: https://github.com/tddschn/alfred-workflow-tddschn/tree/v2
[alabaster]: https://github.com/bitprophet/alabaster
[bitprophet]: https://github.com/bitprophet
[cc]: https://creativecommons.org/licenses/by-nc/4.0/legalcode
[coveralls]: https://coveralls.io/r/tddschn/alfred-workflow-tddschn?branch=master
[deanishe]: https://github.com/deanishe
[docs-contributing]: http://www.deanishe.net/alfred-workflow/contributing.html
[docs-tutorial]: http://www.deanishe.net/alfred-workflow/tutorial.html
[docs-api]: http://www.deanishe.net/alfred-workflow/api/
[docs]: http://www.deanishe.net/alfred-workflow/
[docs-workflows]: http://www.deanishe.net/alfred-workflow/aw-workflows.html
[dash]: https://github.com/tddschn/alfred-workflow-tddschn/raw/master/docs/alfred-workflow-tddschn.docset.zip
[fniephaus]: https://github.com/fniephaus
[owenwater]: https://github.com/owenwater
[issues]: https://github.com/tddschn/alfred-workflow-tddschn/issues
[landscape]: https://landscape.io/github/tddschn/alfred-workflow-tddschn/master
[packal]: http://www.packal.org/
[pep8]: http://legacy.python.org/dev/peps/pep-0008/
[pulls]: https://github.com/tddschn/alfred-workflow-tddschn/pulls
[pypi]: https://pypi.python.org/pypi/alfred-workflow-tddschn/
[releases]: https://github.com/tddschn/alfred-workflow-tddschn/releases
[repo]: https://github.com/tddschn/alfred-workflow-tddschn
[urllib]: https://docs.python.org/3/library/urllib.html
[rtd]: https://readthedocs.org/
[shield-coveralls]: https://coveralls.io/repos/github/tddschn/alfred-workflow-tddschn/badge.svg?branch=master
[shield-docs]: https://readthedocs.org/projects/alfredworkflow/badge/?version=latest&style=flat
[shield-download]: https://img.shields.io/pypi/dm/alfred-workflow-tddschn.svg?style=flat
[shield-github]: https://github.com/tddschn/alfred-workflow-tddschn/workflows/CI/badge.svg
[action-github]: https://github.com/tddschn/alfred-workflow-tddschn/actions?query=workflow%3ACI
[shield-health]: https://landscape.io/github/tddschn/alfred-workflow-tddschn/master/landscape.png?style=flat
[shield-License]: https://pypip.in/license/alfred-workflow-tddschn/badge.svg?style=flat
[shield-status]: https://img.shields.io/pypi/status/alfred-workflow-tddschn.svg?style=flat
[shield-travis]: https://travis-ci.org/tddschn/alfred-workflow-tddschn.svg?branch=master&style=flat
[shield-version]: https://img.shields.io/pypi/v/alfred-workflow-tddschn.svg?style=flat
[shield-pyversions]: https://img.shields.io/pypi/pyversions/alfred-workflow-tddschn.svg?style=flat
[smargh]: https://github.com/smargh
[sphinx]: http://sphinx-doc.org/
[travis]: https://travis-ci.org/tddschn/alfred-workflow-tddschn
[cheeseshop]: https://pypi.python.org/pypi
[pip-docs]: https://pip.pypa.io/en/latest/
[ruby-template]: http://zhaocai.github.io/alfred2-ruby-template/
[python-keyring]: https://pypi.python.org/pypi/keyring
