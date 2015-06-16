#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Author: Martin Hatina <mhatina@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2015 Red Hat, Inc.
#
#   This copyrighted material is made available to anyone wishing
#   to use, modify, copy, or redistribute it subject to the terms
#   and conditions of the GNU General Public License version 2.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE. See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public
#   License along with this program; if not, write to the Free
#   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#   Boston, MA 02110-1301, USA.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/bin/rhts-environment.sh || exit 1
. /usr/share/beakerlib/beakerlib.sh || exit 1

GIT_REPO="https://github.com/storaged-project/storaged.git"
REPO_DIR="storaged"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm git

        rlRun "cd /home/storaged"
        rlRun "su -c 'git clone $GIT_REPO' storaged"
        rlRun "cd $REPO_DIR"
        rlRun "yum install -y $(cat rpm_dependencies.txt)"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "su -c './autogen.sh' storaged"
        rlRun "su -c './configure --enable-modules --localstatedir=/var' storaged"
        rlRun "su -c 'make' storaged"

        rlRun "make install"
        rlRun "cp data/org.storaged.Storaged.conf /etc/dbus-1/system.d/"
        rlRun "cp data/org.storaged.Storaged.policy /usr/share/polkit-1/"
        rlRun "cp modules/lvm2/data/org.storaged.Storaged.lvm2.policy /usr/share/polkit-1/"
    rlPhaseEnd

    rlPhaseStartCleanup
    rlPhaseEnd

rlJournalPrintText
rlJournalEnd
