#!/bin/bash

# exit if a command fails
set -e

# --- Required parameters check
if [ -z "${version_gradle_file}" ] ; then
  echo " [!] Missing required input: version_gradle_file"
  exit 1
fi

if [ ! -f "${version_gradle_file}" ] ; then
  echo " [!] File doesn't exist: ${version_gradle_file}"
  exit 1
fi
echo " (i) Gradle version file: ${version_gradle_file}"
echo " (i) Version code offset: ${version_code_offset}"

# --- Extract versionCode from version.gradle file
version_code=`grep versionCode ${version_gradle_file} | sed 's/^[[:blank:]]*versionCode[[:blank:]]*=[[:blank:]]*\([[:digit:]]*\).*$/\1/'`
if [ -z "${version_code}" ] ; then
  echo " [!] Could not find versionCode in ${version_gradle_file}!"
  exit 1
fi
echo " (i) Current versionCode: ${version_code}"

# --- Extract versionName from version.gradle file
version_name=`grep -m 1 versionName ${version_gradle_file} | sed 's/^[[:blank:]]*versionName[[:blank:]]*=[[:blank:]]*\"\([^\"]*\)\".*$/\1/'`
if [ -z "${version_name}" ] ; then
  echo " [!] Could not find versionName in ${version_gradle_file}!"
  exit 1
fi
echo " (i) Current versionName: ${version_name}"

# --- Compute version_code_offset
new_version_code=$((${version_code} + ${version_code_offset}))
echo " (i) New versionCode: ${new_version_code}"

# --- Compute new_version_name by replacing or appending new_version_code in/to version_name
if [[ $version_name =~ \.$version_code$ ]]; then
  #echo " (i) replacing versionCode '.${VERSIONCODE}' in '${VERSIONNAME}' with '${NEWVERSIONCODE}'"
  new_version_name=`sed "s/.${version_code}$/.${new_version_code}/" <<< $version_name`
else
  #echo " (i) appending '.${NEWVERSIONCODE}' to ${VERSIONNAME}"
  new_version_name="${version_name}.${new_version_code}"
fi
echo " (i) New versionName: ${new_version_name}"


# --- Replace versionCode and versionName in version.gradle file
sed -i.bak "s/\(versionCode[[:blank:]]*=[[:blank:]]*\)${version_code}/\1${new_version_code}/" ${version_gradle_file}
sed -i.bak2 "s/\(versionName[[:blank:]]*=[[:blank:]]*\"\)${version_name}\"/\1${new_version_name}\"/" ${version_gradle_file}

# ---- Remove backups:
rm -f ${version_gradle_file}.bak2
rm -f ${version_gradle_file}.bak

# ---- output environment variables
envman add --key GRADLE_VERSION_CODE --value "${new_version_code}"
envman add --key GRADLE_VERSION_NAME --value "${new_version_name}"

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
#  envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.

