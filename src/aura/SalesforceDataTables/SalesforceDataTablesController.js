({
    doInit : function(cmp, event, helper) {
        var canCreate = cmp.get('v.canCreate');
        var canEdit = cmp.get('v.canEdit');
        var canRemove = cmp.get('v.canRemove');
        var eventButtons = cmp.get('v.eventButtons');

        var requiresEditor = canCreate || canEdit || canRemove;
        var hasButtons = eventButtons.length > 0;
        var hasSelectableButtons = helper.getSelectableButtons(eventButtons).length > 0;

        var style = cmp.get('v.style');
        if (style != 'classic' && style != 'bootstrap' && style != 'SLDS') {
            style = 'classic';
        }

        var _styles = [];
        var _scripts = [];

        _styles.push(cmp.get('v.__typeahead_CSS'));
        if (style == 'classic') {
            _styles.push(cmp.get('v.__dataTables_CSS'));
            _styles.push(cmp.get('v.__salesforce_common_CSS'));
        }
        if (style == 'bootstrap') {
            //_styles.push(cmp.get('v.__bootstrap_CSS'));
            _styles.push(cmp.get('v.__dataTables_bootstrap_CSS'));
        }
        if (style == 'SLDS') {
            _styles.push(cmp.get('v.__SLDS_CSS'));
            _styles.push(cmp.get('v.__dataTables_SLDS_CSS'));
        }
        if (requiresEditor || hasButtons) {
            _styles.push(cmp.get('v.__dataTables_Buttons_CSS'));
        }
        if (requiresEditor || hasSelectableButtons) {
            _styles.push(cmp.get('v.__dataTables_Select_CSS'));
        }
        if (requiresEditor) {
            if (style == 'classic') {
                _styles.push(cmp.get('v.__Editor_CSS'));
            }
            if (style == 'bootstrap') {
                _styles.push(cmp.get('v.__Editor_bootstrap_CSS'));
            }
            if (style == 'SLDS') {
                _styles.push(cmp.get('v.__Editor_SLDS_CSS'));
            }
        }


        if (!window.jQuery) {
            _scripts.push(cmp.get('v.__jQuery'));
            if (style == 'bootstrap' && requiresEditor) {
                _scripts.push(cmp.get('v.__bootstrap'));
            }
            _scripts.push(cmp.get('v.__dataTables'));
            if (style == 'bootstrap') {
                _scripts.push(cmp.get('v.__dataTables_bootstrap'));
            }
            if (requiresEditor || hasButtons) {
                _scripts.push(cmp.get('v.__dataTables_Buttons'));
            }
            if (requiresEditor || hasSelectableButtons) {
                _scripts.push(cmp.get('v.__dataTables_Select'));
            }
            if (requiresEditor) {
                _scripts.push(cmp.get('v.__Editor'));
                if (style == 'bootstrap') {
                    _scripts.push(cmp.get('v.__Editor_bootstrap'));
                }
            }
            _scripts.push(cmp.get('v.__keyTable'));
            _scripts.push(cmp.get('v.__moment'));
            _scripts.push(cmp.get('v.__datetimepicker'));
            _scripts.push(cmp.get('v.__typeahead'));
        } else {
            if (!window.jQuery.fn.modal && style == 'bootstrap' && requiresEditor) {
                _scripts.push(cmp.get('v.__bootstrap'));
            }
            if (!window.jQuery.fn.DataTable) {
                _scripts.push(cmp.get('v.__dataTables'));
                if (style == 'bootstrap') {
                    _scripts.push(cmp.get('v.__dataTables_bootstrap'));
                }
                _scripts.push(cmp.get('v.__keyTable'));
                if (requiresEditor || hasButtons) {
                    _scripts.push(cmp.get('v.__dataTables_Buttons'));
                }
                if (requiresEditor || hasSelectableButtons) {
                    _scripts.push(cmp.get('v.__dataTables_Select'));
                }
                if (requiresEditor) {
                    _scripts.push(cmp.get('v.__Editor'));
                    if (style == 'bootstrap') {
                        _scripts.push(cmp.get('v.__Editor_bootstrap'));
                    }
                }
            } else {
                if (!window.jQuery.fn.dataTable.KeyTable) {
                    _scripts.push(cmp.get('v.__keyTable'));
                }
                if ((requiresEditor || customButtons) && !window.jQuery.fn.dataTable.Buttons) {
                    _scripts.push(cmp.get('v.__dataTables_Buttons'));
                }
                if ((requiresEditor || customButtons) && !window.jQuery.fn.dataTable.select) {
                    _scripts.push(cmp.get('v.__dataTables_Select'));
                }
                if (requiresEditor && !window.jQuery.fn.dataTable.Editor) {
                    _scripts.push(cmp.get('v.__Editor'));
                    if (style == 'bootstrap') {
                        _scripts.push(cmp.get('v.__Editor_bootstrap'));
                    }
                }
            }
            if (!window.jQuery.fn.moment) {
                _scripts.push(cmp.get('v.__moment'));
            }
            if (!window.jQuery.fn.datetimepicker) {
                _scripts.push(cmp.get('v.__datetimepicker'));
            }
            if (!window.jQuery.fn.typeahead) {
                _scripts.push(cmp.get('v.__typeahead'));
            }
        }

        cmp.set('v._styles', _styles);
        cmp.set('v._scripts', _scripts);
        cmp.set('v._isInitDone', true);
    },
    
    afterScriptsLoaded : function(cmp, event, helper) {
        helper.beforeStart(cmp);
    },

    dismissErrorMessage : function(cmp, event, helper) {
        cmp.set('v._errorMessage', '');
        cmp.set('v._displayErrorMessage', false);
    },

    handleIncomingEvent : function(cmp, event, helper) {
        var message = event.getParam('message');
        var data = event.getParam('data');

        var found = message.match(/updateAttribute:(.+)/);
        if (found) {
            cmp.set('v.' + found[1], data);
            helper.pullData(cmp);
        }
    }
})