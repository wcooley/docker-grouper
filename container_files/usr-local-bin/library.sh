#!/bin/sh

echo "grouperContainer; INFO: (library.sh) Start loading library.sh"
. /usr/local/bin/libraryPrep.sh
. /usr/local/bin/libraryPrepOnly.sh
. /usr/local/bin/libraryRunCommand.sh
. /usr/local/bin/librarySetupFiles.sh
. /usr/local/bin/librarySetupFilesApache.sh
. /usr/local/bin/librarySetupFilesForComponent.sh
. /usr/local/bin/librarySetupFilesForProcess.sh
. /usr/local/bin/librarySetupFilesTomcat.sh
. /usr/local/bin/librarySetupPipe.sh

# base definitions of hooks
. /usr/local/bin/grouperScriptHooksBase.sh

# implementations of custom hooks
. /usr/local/bin/grouperScriptHooks.sh
echo "grouperContainer; INFO: (library.sh) End loading library.sh"

