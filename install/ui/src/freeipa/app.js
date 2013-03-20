/*  Authors:
 *    Petr Vobornik <pvoborni@redhat.com>
 *
 * Copyright (C) 2012 Red Hat
 * see file 'COPYING'./for use and warranty information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/**
 * Application wrapper
 */
define([
    //core
    'dojo/_base/lang',
    'dojo/Deferred',
    'dojo/when',
    './plugin_loader',
    './phases',
    './Application_controller',
    'exports', // for circullar deps
    './ipa',
    './jquery',
    //only entities
    './aci',
    './automember',
    './automount',
    './dns',
    './group',
    './hbac',
    './hbactest',
    './hostgroup',
    './host',
    './idrange',
    './netgroup',
    './policy',
    './realmdomains',
    './rule',
    './selinux',
    './serverconfig',
    './service',
    './sudo',
    './trust',
    './user',
    'dojo/domReady!'
],function(lang, Deferred, when, plugin_loader, phases, Application_controller, exports) {

    var app = {

        /**
         * Application instance
         */
        app: null,

        /**
         * Application class
         */
        App_class: Application_controller,

        /**
         * Phases registration
         */
        register_phases: function() {

            phases.on('init', lang.hitch(this, function() {
                var app = this.app = new this.App_class();
                app.init();
                return app;
            }));

            phases.on('metadata', lang.hitch(this, function() {
                var deferred = new Deferred();

                this.app.get_configuration(function(success) {
                    deferred.resolve(success);
                }, function(error) {
                    deferred.reject(error);
                });

                return deferred.promise;
            }));

            phases.on('profile', lang.hitch(this, function() {
                this.app.choose_profile();
            }));

            phases.on('runtime', lang.hitch(this, function() {
                return this.app.start_runtime();
            }));

            phases.on('shutdown', lang.hitch(this, function() {
                return this.app.start_logout();
            }));
        },

        run: function() {
            when(plugin_loader.load_plugins(), lang.hitch(this, function() {
                this.register_phases();
                phases.controller.run();
            }));
        }
    };

    lang.mixin(exports, app);

    return exports;
});