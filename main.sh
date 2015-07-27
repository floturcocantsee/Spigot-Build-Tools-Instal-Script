#!/bin/bash

## Script to get the latest version of build tools and compile it ##

# Variables #
WRITE_DIR=/Your/Directory/Here/Spigot-Build-$(date +%Y%m%d)
KEEP_BUKKIT="Yes" # (Yes/No) *Case Sensitive
KEEP_BUILD_FOLDERS="Yes" # (Yes/No) *Case Sensitive

# Begin Script Body #
cd ./ # Change directory to scripts directory

if [ -e BuildTools.jar ]
then
	echo "[INFO] Found BuildTools.jar"
else
	echo "[WARNING] Couldn't find BuildTools.jar! It will be downloaded for you."
	wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
fi

java -jar BuildTools.jar # Compile Spigot using BuildTools.

if [ -e $WRITE_DIR ]
then
	echo "[WARNING] Directory attempted to be written to exists will write to the /tmp directory instead!"
	mv spigot-*.jar /tmp
else
	echo "[INFO] Writing spigot.jar to directory $WRITE_DIR"
	mkdir $WRITE_DIR
	mv spigot-*.jar $WRITE_DIR
fi

echo "[INFO] Starting Cleanup"

if [ $KEEP_BUKKIT == "Yes" ]
then
	echo "[INFO] KEEP_BUKKIT is set to $KEEP_BUKKIT the file craftbukkit.jar will be written to the spigot directory!"
	mv craftbukkit*.jar $WRITE_DIR
else
	echo "[INFO] KEEP_BUKKIT is set to $KEEP_BUKKIT the file craftbukkit.jar will be discarded!"
	rm craftbukkit*.jar
fi

if [ $KEEP_BUILD_FOLDERS == "Yes" ]
then
	echo "[INFO] KEEP_BUILD_FOLDERS is set to $KEEP_BUILD_FOLDERS the files/folders used in the compilation process will be kept!"
	exit
else
	echo "[INFO] KEEP_BUILD_FOLDERS is set to $KEEP_BUILD_FOLDERS the files/folders used in the compilation process will be removed!"
	rm -rf apache-maven*/ BuildData*/ BuildTools*log* work*/ Spigot*/ Craftbukkit*/ Bukkit*/
	exit
