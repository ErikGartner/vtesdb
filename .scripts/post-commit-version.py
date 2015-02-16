#!/usr/bin/env python
import os
import json
from subprocess import Popen, PIPE

# get branch name
process = Popen(['git','rev-parse', '--abbrev-ref', 'HEAD'], stdout=PIPE)
(branch, err) = process.communicate()
exit_code = process.wait()

process = Popen(['git','rev-parse', 'HEAD'], stdout=PIPE)
(commit, err) = process.communicate()
exit_code = process.wait()

process = Popen(['git','log', '-1', '--date=short', '--pretty=format:%cd'], stdout=PIPE)
(time, err) = process.communicate()
exit_code = process.wait()

output = {'commit': commit.decode('utf-8').strip(),
          'branch': branch.decode('utf-8').strip(),
          'timestamp': time.decode('utf-8').strip()}

json_string = json.dumps(output, indent=4, separators=(',', ': '))
with open('private/version.json', 'w') as text_file:
    text_file.write(json_string)

exit(0)
