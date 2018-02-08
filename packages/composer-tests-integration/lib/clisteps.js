/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

module.exports = function () {

    this.Given(/^I have generated crypto material/, function () {
        return this.composer.setup();
    });

    this.Given(/^I have the following (.+?)$/, function (type, table) {
        return this.composer.checkExists(type, table);
    });

    this.When(/^I run the following CLI command/, {timeout: 240 * 1000}, function (table) {
        return this.composer.runCLI(table);
    });

    this.When(/^I substitue the alias (.*?) and run the following CLI command$/, {timeout: 240 * 1000}, function (alias, table) {
        return this.composer.runCLIWithAlias(alias, table);
    });

    this.When(/^I spawn the following background task (.+?), and wait for \/(.+?)\/$/, {timeout: 240 * 1000}, function (label, regex, table) {
        return this.composer.runBackground(label, table, new RegExp(regex));
    });

    this.When(/^I kill task named (.+?)$/, {timeout: 240 * 1000}, function (label) {
        return this.composer.killBackground(label);
    });

    this.When(/^I save group (.+?) from the console output matching pattern (.+?) as alias (.*?)$/, function (group, regex, alias) {
        return this.composer.saveMatchingGroupAsAlias(new RegExp(regex, 'g'), group, alias);
    });

    this.Then(/^The stdout information should include text matching \/(.+?)\/$/, function (regex) {
        return this.composer.checkConsoleOutput(new RegExp(regex), false);
    });

    this.Then(/^The stderr information should include text matching \/(.+?)\/$/, function (regex) {
        return this.composer.checkConsoleOutput(new RegExp(regex), true);
    });

    this.Then(/^A new file matching this regex should be created \/(.+?)\/$/, function (regex) {
        return this.composer.checkFileWasCreated(new RegExp(regex));
    });
};