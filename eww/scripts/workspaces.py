#! /usr/bin/env python3
# [{
#     "id": 1,
#     "name": "1",
#     "monitor": "DP-1",
#     "monitorID": 0,
#     "windows": 1,
#     "hasfullscreen": false,
#     "lastwindow": "0x57b9a2e9d3f0",
#     "lastwindowtitle": "tmux"
# },{
#     "id": 2,
#     "name": "2",
#     "monitor": "DP-2",
#     "monitorID": 1,
#     "windows": 1,
#     "hasfullscreen": false,
#     "lastwindow": "0x57b9b04b0080",
#     "lastwindowtitle": "eww-widgets/eww/bar/scripts/workspace at main · saimoomedits/eww-widgets — Mozilla Firefox"
# },{
#     "id": 3,
#     "name": "3",
#     "monitor": "DP-2",
#     "monitorID": 1,
#     "windows": 1,
#     "hasfullscreen": false,
#     "lastwindow": "0x57b9a34c3e80",
#     "lastwindowtitle": "Ed Sheeran - Bibia Be Ye Ye"
# }]

import argparse
import json
from dataclasses import dataclass
import subprocess
import time


@dataclass
class Workspace:
    id: int
    name: str
    monitor: str
    monitorID: int
    windows: int
    hasfullscreen: bool
    lastwindowtitle: str
    is_active: bool

    def to_yuck(self) -> str:
        cls = 'workspace_button' if not self.is_active else 'active_workspace_button'
        command = f'hyprctl dispatch workspace {self.id}'

        return f'(button :class "{cls}" :onclick "{command}" {self.id})'


def workspace_from_json(workspace_json: dict) -> Workspace:
    return Workspace(
        id = workspace_json['id'],
        name = workspace_json['name'],
        monitor = workspace_json['monitor'],
        monitorID = workspace_json['monitorID'],
        windows = workspace_json['windows'],
        hasfullscreen = workspace_json['hasfullscreen'],
        lastwindowtitle = workspace_json['lastwindowtitle'],
        is_active = False
    )


def get_active_workspace() -> Workspace:
    active_workspace_json = json.loads(subprocess.check_output(['hyprctl', 'activeworkspace', '-j']))

    ws = workspace_from_json(active_workspace_json)
    ws.is_active = True

    return ws


def get_all_workspaces() -> list[Workspace]:
    workspaces_json = json.loads(subprocess.check_output(['hyprctl', 'workspaces', '-j']))

    return [workspace_from_json(j) for j in workspaces_json]


def workspaces_to_yuck(active: Workspace, all: list[Workspace]) -> str:

    workspaces: list[Workspace] = []

    for workspace in all:
        if workspace.id == active.id:
            workspaces.append(active)
        else:
            workspaces.append(workspace)

    # TODO: group these by monitor and separate accordingly

    workspaces.sort(key=lambda w: w.id)

    as_yuck = [workspace.to_yuck() for workspace in workspaces]

    return f"""
(box :class "workspaces"
     :orientation: "h"
     :space-evenly true
     :halign "start"
     :spacing 10
        {'\n\t'.join(as_yuck)}
)
    """.strip().replace('\n', '')


def main() -> None:
    parser = argparse.ArgumentParser('workspaces.py')

    parser.add_argument('-d', '--debug', help='Print debug output', action='store_true')
    parser.add_argument('-e', '--eww', help='Whether or not to output eww stuff', action='store_true')
    parser.add_argument('-ep', '--eww-poll', help='Eww poll mode (single shot print)', action='store_true')

    args = parser.parse_args()

    all_workspaces = get_all_workspaces()
    active_workspace = get_active_workspace()

    if args.debug:
        print(f'active workspace: {active_workspace}')
        print(f'all workspaces: {all_workspaces}')
        return

    if args.eww_poll:
        all_workspaces = get_all_workspaces()
        active_workspace = get_active_workspace()

        print(workspaces_to_yuck(active_workspace, all_workspaces))
        return

    if args.eww:
        while True:
            time.sleep(0.1) # NOTE: time.sleep is essential here to not kill the PC...

            all_workspaces = get_all_workspaces()
            active_workspace = get_active_workspace()

            print(workspaces_to_yuck(active_workspace, all_workspaces))


if __name__ == '__main__':
    main()
