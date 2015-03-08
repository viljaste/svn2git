# svn2git

Migrates SVN repository with history to Git repository.

## Usage

    svn2git [SOURCE] <DESTINATION>

    Options:
      -u, --username=""
      -p, --password=""

## Install

    TMP="$(mktemp -d)" \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/svn2git.git "${TMP}" \
      && sudo cp "${TMP}/svn2git.sh" /usr/local/bin/svn2git \
      && sudo chmod +x /usr/local/bin/svn2git

## License

**MIT**
