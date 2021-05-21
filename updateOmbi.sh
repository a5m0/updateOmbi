#!/bin/bash
DOWNLOAD=linux-x64.tar.gz
SERVICE_NAME=ombi
OMBI_URL=https://github.com/Ombi-app/Ombi.Releases/releases
VERSION=$(curl -s $OMBI_URL | grep "$DOWNLOAD" | grep -Po ".*\/download\/v([0-9\.]+).*" | awk -F'/' '{print $6}' | tr -d 'v' | sort -V | tail -1)
SERVICE_LOC=$(systemctl status $SERVICE_NAME | grep -Po "(?<=loaded \()[^;]+")
WORKING_DIR=$(grep -Po "(?<=WorkingDirectory=).*" $SERVICE_LOC)
INSTALLED_1=$(strings $WORKING_DIR/Ombi | grep -Po 'Ombi/\d+\.\d+\.\d+' | grep -Po '\d+\.\d+\.\d+' | sort -n | tail -n 1)
INSTALLED_2=$(grep -Po "(?<=Ombi/)([\d\.]+)" 2> /dev/null $WORKING_DIR/Ombi.deps.json | head -1)
STORAGE_DIR=/etc/Ombi/
KEEP_BACKUP=yes
SUPPRESS_OUTPUT=no
SLACK_URL=https://hooks.slack.com/services/
SLACK_WEBHOOK=
MESSAGE="Updating $SERVICE_NAME to v$VERSION"
SLACK_CHANNEL=alerts
SLACK_USER=ombi
DISCORD_WEBHOOK=

# Start script
# Privileges check
if [ "$EUID" -ne 0 ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [WARNING] Not running as root. You must have your sudoers file configured correctly."
	fi
fi

# Check for version info in the executable
if [ ! -z "$INSTALLED_1" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] $SERVICE_NAME v$INSTALLED_1 detected. Continuing..."
	fi
        INSTALLED=$INSTALLED_1
# Check for version info before it was in the executable
elif [ ! -z "$INSTALLED_2" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") $SERVICE_NAME v$INSTALLED_2 [INFO] detected. Continuing..."
	fi
        INSTALLED=$INSTALLED_2
else
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Currently installed version of $SERVICE_NAME not detected. Exiting."
	fi
        exit 1
fi

if [ "$INSTALLED" = "$VERSION" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] $SERVICE_NAME is up to date"
	fi
	exit 0
elif [ -z $VERSION ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Latest version of $SERVICE_NAME not found. Exiting."
	fi
        exit 1
else
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Updating $SERVICE_NAME to v$VERSION"
	fi

# POST to Slack
	curl -s -o /dev/null -X POST --data "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USER\", \"text\": \":exclamation: ${MESSAGE} \"}" $SLACK_URL$SLACK_WEBHOOK
# POST to Discord
	curl -s -o /dev/null -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $DISCORD_WEBHOOK
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo  "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Stopping $SERVICE_NAME"
fi

systemctl stop $SERVICE_NAME
if [ $? = 1 ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] User does not have the permission to control $SERVICE_NAME service"
	fi
        exit 1
fi

# Check to see if directory has a forward slash at the end and correct it
if [[ $WORKING_DIR = */ ]]; then
        WORKING_DIR=$(echo $WORKING_DIR | sed 's/.$//')
else
        WORKING_DIR=$WORKING_DIR
fi

BACKUP_DIR=$WORKING_DIR.$INSTALLED
TEMP_DIR=$WORKING_DIR.$VERSION#!/bin/bash
DOWNLOAD=linux-x64.tar.gz
SERVICE_NAME=ombi
OMBI_URL=https://github.com/Ombi-app/Ombi.Releases/releases
VERSION=$(curl -s $OMBI_URL | grep "$DOWNLOAD" | grep -Po ".*\/download\/v([0-9\.]+).*" | awk -F'/' '{print $6}' | tr -d 'v' | sort -V | tail -1)
SERVICE_LOC=$(systemctl status $SERVICE_NAME | grep -Po "(?<=loaded \()[^;]+")
WORKING_DIR=$(grep -Po "(?<=WorkingDirectory=).*" "$SERVICE_LOC")
INSTALLED_1=$(strings "$WORKING_DIR"/Ombi | grep -Po 'Ombi/\d+\.\d+\.\d+' | grep -Po '\d+\.\d+\.\d+' | sort -n | tail -n 1)
INSTALLED_2=$(grep -Po "(?<=Ombi/)([\d\.]+)" 2> /dev/null "$WORKING_DIR"/Ombi.deps.json | head -1)
STORAGE_DIR=/etc/Ombi/
KEEP_BACKUP=yes
SUPPRESS_OUTPUT=no
SLACK_URL=https://hooks.slack.com/services/
SLACK_WEBHOOK=
MESSAGE="Updating $SERVICE_NAME to v$VERSION"
SLACK_CHANNEL=alerts
SLACK_USER=ombi
DISCORD_WEBHOOK=

# Start script
# Privileges check
if [[ "$EUID" -ne 0 ]]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [WARNING] Not running as root. You must have your sudoers file configured correctly."
	fi
fi

# Check for version info in the executable
if [ -n "$INSTALLED_1" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] $SERVICE_NAME v$INSTALLED_1 detected. Continuing..."
	fi
        INSTALLED=$INSTALLED_1
# Check for version info before it was in the executable
elif [ -n "$INSTALLED_2" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") $SERVICE_NAME v$INSTALLED_2 [INFO] detected. Continuing..."
	fi
        INSTALLED=$INSTALLED_2
else
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Currently installed version of $SERVICE_NAME not detected. Exiting."
	fi
        exit 1
fi

if [ "$INSTALLED" = "$VERSION" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] $SERVICE_NAME is up to date"
	fi
	exit 0
elif [ -z "$VERSION" ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Latest version of $SERVICE_NAME not found. Exiting."
	fi
        exit 1
else
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Updating $SERVICE_NAME to v$VERSION"
	fi

# POST to Slack
	curl -s -o /dev/null -X POST --data "payload={\"channel\": \"#$SLACK_CHANNEL\", \"username\": \"$SLACK_USER\", \"text\": \":exclamation: ${MESSAGE} \"}" "$SLACK_URL$SLACK_WEBHOOK"
# POST to Discord
	curl -s -o /dev/null -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$DISCORD_WEBHOOK"
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo  "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Stopping $SERVICE_NAME"
fi

systemctl stop $SERVICE_NAME
if [ $? = 1 ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] User does not have the permission to control $SERVICE_NAME service"
	fi
        exit 1
fi

# Check to see if directory has a forward slash at the end and correct it
if [[ $WORKING_DIR = */ ]]; then
        WORKING_DIR=$(echo "$WORKING_DIR" | sed 's/.$//')
else
        WORKING_DIR=$WORKING_DIR
fi

BACKUP_DIR=$WORKING_DIR/../ombi.$INSTALLED
TEMP_DIR=$WORKING_DIR/../ombi.$VERSION

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Creating temporary directory $TEMP_DIR"
fi
mkdir "$TEMP_DIR"
mkdir "$BACKUP_DIR"
cd "$TEMP_DIR"

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Downloading $SERVICE_NAME"
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	wget -N $OMBI_URL/download/v"$VERSION"/$DOWNLOAD
else
	wget -Nq $OMBI_URL/download/v"$VERSION"/$DOWNLOAD
fi

if [ $? -ne 0 ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Failed to download"
		rm -f $DOWNLOAD
	fi
   exit 1
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Extracting $DOWNLOAD"
fi
tar -xf $DOWNLOAD

if [ $? -ne 0 ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
                echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Failed to extract $DOWNLOAD"
                rm -f $DOWNLOAD
        fi
   exit 1
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Shuffling directories"
fi
mv "$WORKING_DIR"/* "$BACKUP_DIR"
mv "$TEMP_DIR"/* "$WORKING_DIR"
rm -rf "$TEMP_DIR"

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Copying over files from $BACKUP_DIR"
fi

if [ -f $STORAGE_DIR/database.json ]; then
  cp $STORAGE_DIR/database.json "$WORKING_DIR"
fi

if [ -f "$BACKUP_DIR"/database.json ]; then
  cp "$BACKUP_DIR"/database.json "$WORKING_DIR"
fi

if [ -f $STORAGE_DIR/database_multi.json ]; then
  cp $STORAGE_DIR/database_multi.json "$WORKING_DIR"
fi

if [ -f "$BACKUP_DIR"/database_multi.json ]; then
  cp "$BACKUP_DIR"/database_multi.json "$WORKING_DIR"
fi

if [ -f $STORAGE_DIR/Ombi.db ]; then
  cp $STORAGE_DIR/Ombi.db "$WORKING_DIR"
fi

if [ -f "$BACKUP_DIR"/Ombi.db ]; then
  cp "$BACKUP_DIR"/Ombi.db "$WORKING_DIR"
fi

if [ -f $STORAGE_DIR/OmbiSettings.db ]; then
  cp $STORAGE_DIR/OmbiSettings.db "$WORKING_DIR"
fi

if [ -f "$BACKUP_DIR"/OmbiSettings.db ]; then
  cp "$BACKUP_DIR"/OmbiSettings.db "$WORKING_DIR"
fi

if [ -f $STORAGE_DIR/OmbiExternal.db ]; then
  cp $STORAGE_DIR/OmbiExternal.db "$WORKING_DIR"
fi

if [ -f "$BACKUP_DIR"/OmbiExternal.db ]; then
  cp "$BACKUP_DIR"/OmbiExternal.db "$WORKING_DIR"
fi

cp -rn "$BACKUP_DIR"/wwwroot/images/* "$WORKING_DIR"/wwwroot/images || true

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing ownership to $SERVICE_NAME"
fi
chown -R $SERVICE_NAME:$SERVICE_NAME "$WORKING_DIR"

if [ $KEEP_BACKUP == 'yes' ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Keeping $BACKUP_DIR"
	fi
elif [ $KEEP_BACKUP == 'no' ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Deleting $BACKUP_DIR"
	fi
   rm -rf "$BACKUP_DIR"
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Starting $SERVICE_NAME"
fi
systemctl start $SERVICE_NAME


if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Creating temporary directory $TEMP_DIR"
fi
mkdir $TEMP_DIR
cd $TEMP_DIR

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Downloading $SERVICE_NAME"
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	wget -N $OMBI_URL/download/v$VERSION/$DOWNLOAD
else
	wget -Nq $OMBI_URL/download/v$VERSION/$DOWNLOAD
fi

if [ $? -ne 0 ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Failed to download"
		rm -f $DOWNLOAD
	fi
   exit 1
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Extracting $DOWNLOAD"
fi
tar -xf $DOWNLOAD

if [ $? -ne 0 ]; then
        if [ $SUPPRESS_OUTPUT = 'no' ]; then
                echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [ERROR] Failed to extract $DOWNLOAD"
                rm -f $DOWNLOAD
        fi
   exit 1
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Shuffling directories"
fi
mv $WORKING_DIR/* $BACKUP_DIR
mv $TEMP_DIR/* $WORKING_DIR

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Copying over files from $BACKUP_DIR"
fi

if [ -f $STORAGE_DIR/database.json ]; then
  cp $STORAGE_DIR/database.json $WORKING_DIR
fi

if [ -f $BACKUP_DIR/database.json ]; then
  cp $BACKUP_DIR/database.json $WORKING_DIR
fi

if [ -f $STORAGE_DIR/database_multi.json ]; then
  cp $STORAGE_DIR/database_multi.json $WORKING_DIR
fi

if [ -f $BACKUP_DIR/database_multi.json ]; then
  cp $BACKUP_DIR/database_multi.json $WORKING_DIR
fi

if [ -f $STORAGE_DIR/Ombi.db ]; then
  cp $STORAGE_DIR/Ombi.db $WORKING_DIR
fi

if [ -f $BACKUP_DIR/Ombi.db ]; then
  cp $BACKUP_DIR/Ombi.db $WORKING_DIR
fi

if [ -f $STORAGE_DIR/OmbiSettings.db ]; then
  cp $STORAGE_DIR/OmbiSettings.db $WORKING_DIR
fi

if [ -f $BACKUP_DIR/OmbiSettings.db ]; then
  cp $BACKUP_DIR/OmbiSettings.db $WORKING_DIR
fi

if [ -f $STORAGE_DIR/OmbiExternal.db ]; then
  cp $STORAGE_DIR/OmbiExternal.db $WORKING_DIR
fi

if [ -f $BACKUP_DIR/OmbiExternal.db ]; then
  cp $BACKUP_DIR/OmbiExternal.db $WORKING_DIR
fi

cp -rn $BACKUP_DIR/wwwroot/images/* $WORKING_DIR/wwwroot/images || true

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Changing ownership to $SERVICE_NAME"
fi
chown -R $SERVICE_NAME:$SERVICE_NAME $WORKING_DIR

if [ $KEEP_BACKUP == 'yes' ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Keeping $BACKUP_DIR"
	fi
elif [ $KEEP_BACKUP == 'no' ]; then
	if [ $SUPPRESS_OUTPUT = 'no' ]; then
		echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Deleting $BACKUP_DIR"
	fi
   rm -rf $BACKUP_DIR
fi

if [ $SUPPRESS_OUTPUT = 'no' ]; then
	echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") [INFO] Starting $SERVICE_NAME"
fi
systemctl start $SERVICE_NAME
