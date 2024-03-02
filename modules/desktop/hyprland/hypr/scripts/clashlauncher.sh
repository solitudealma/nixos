#!/bin/bash

launch_clash() {
	killall -9 .clash-verge-wr

	clash-verge &
}

launch_clash
