({
    displayError : function(cmp, errorMessage) {
        console.log(errorMessage);
        cmp.set('v._displayErrorMessage', true);
        cmp.set('v._errorMessage', errorMessage);
    },
    
    isStylesheetLoaded : function(cssName) {
        var styles = document.styleSheets;
        var found = false;
        
        for (var i = 0; i < styles.length; i++) {
            if (styles[i].href.match(cssName)) {
                if (styles[i].cssRules != null && styles[i].cssRules.length != 0) {
                    found = true;
                    break;
                }
            }
        }
        
        return found;
    },

    formatNumber : function(number, scale) {
        return number.toFixed(scale).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
    },

    getSelectableButtons : function(eventButtons) {
        return eventButtons.filter(function(e) {
            return e.select;
        });
    },

    getEditorFieldType : function(e) {
        if (e.readOnly) {
            return 'readonly';
        }
        if (e.dataType === 'Date') {
            return 'date';
        }
        if (e.dataType === 'DateTime') {
            return 'datetime';
        }
        if (e.dataType === 'Address') {
            return 'textarea';
        }
        if (e.dataType === 'Boolean') {
            return 'checkbox';
        }
        if (e.dataType === 'Currency') {
            return 'text';
        }
        if (e.dataType === 'ID') {
            return 'text';
        }
        if (e.dataType === 'Reference') {
            return 'text';
        }
        if (e.dataType === 'Double') {
            return 'text';
        }
        if (e.dataType === 'Integer') {
            return 'text';
        }
        if (e.dataType === 'Email') {
            return 'text';
        }
        if (e.dataType === 'Percent') {
            return 'text';
        }
        if (e.dataType === 'Phone') {
            return 'text';
        }
        if (e.dataType === 'Picklist') {
            return 'select';
        }
        if (e.dataType === 'MultiPicklist') {
            return 'checkbox';
        }
        if (e.dataType === 'URL') {
            return 'text';
        }
        if (e.dataType === 'TextArea') {
            return 'textarea';
        }
        if (e.dataType === 'String') {
            return 'text';
        }
    },

    getRelationshipName : function(row, field) {
        return field.relationshipName.split('.').reduce(function(p, c) { return p ? p[c] : p }, row);
    },

    getHiddenIdFieldName : function(field) {
        return '_hiddenID_' + field.name;
    },

    getDefaultFieldValue : function(field) {
        return field.dataType === 'ID' || field.dataType === 'Reference'
                ? field.defaultValue !== undefined && field.defaultNameValue === undefined
                    ? null
                    : field.defaultNameValue
                : field.defaultValue;
    },

    generateEditorFields : function(cmp, editorAction, fieldInfo, fieldArray, labelArray) {
        var helper = this;

        var fields = fieldInfo.fields;
        var requiredFields = fieldInfo.requiredFields;

        var editorFields = [];
        var existingFields = [];

        for (var i = 0, l = fields.length ; i < l ; i++) {
            var e = fields[i];
            var editorField = {
                'name': e.name,
                'label': labelArray[fieldArray.indexOf(e.name)] || e.label,
                'type': helper.getEditorFieldType(e)
            };
            if (e.required) {
                $.extend(editorField, {
                    'className': 'required'
                });
            }

            if (e.dataType === 'Boolean') {
                $.extend(editorField, {
                    'options': [{ label: '', value: true }] ,
                    'separator': ','
                });
            }
            if (e.dataType === 'Picklist') {
                $.extend(editorField, {
                    'options': e.picklistValues,
                    'placeholder': '--None--',
                    'placeholderDisabled': false,
                    'placeholderValue': null
                });
            }
            if (e.dataType === 'ID' || e.dataType === 'Reference') {
                $.extend(editorField, {
                    'data': e.relationshipName
                });
            }
            if (editorAction == 'create') {
                var defaultFieldValue = helper.getDefaultFieldValue(e);
                if (defaultFieldValue === null) {
                    helper.displayError(cmp, 'Will not be able to display default value for ' + e.name + ' on create because' +
                                             ' <strong>defaultValue</strong> was specified but <strong>defaultNameValue</strong> was not');
                } else {
                    if (defaultFieldValue !== undefined) {
                        $.extend(editorField, {
                            'def': defaultFieldValue
                        });
                    }
                }
            }

            editorFields.push(editorField);
            existingFields.push(e.name);
        }

        if (editorAction == 'create') {
            for (var i = 0, l = requiredFields.length ; i < l ; i++) {
                var e = requiredFields[i];
                if (existingFields.indexOf(e.name) == -1) {
                    var editorField = {
                        'name': e.name,
                        'label': labelArray[fieldArray.indexOf(e.name)] || e.label,
                        'type': helper.getEditorFieldType(e),
                        'className': 'required'
                    };
                    if (e.dataType === 'Boolean') {
                        $.extend(editorField, {
                            'options': [{ label: '', value: true }] ,
                            'separator': ','
                        });
                    }
                    var defaultFieldValue = helper.getDefaultFieldValue(e);
                    if (defaultFieldValue === null) {
                        helper.displayError(cmp, 'Will not be able to display default value for ' + e.name + ' on create because' +
                                                 ' <strong>defaultValue</strong> was specified but <strong>defaultNameValue</strong> was not');
                    } else {
                        if (defaultFieldValue !== undefined) {
                            $.extend(editorField, {
                                'def': defaultFieldValue
                            });
                        }
                    }

                    editorFields.push(editorField);
                    existingFields.push(e.name);
                }
            }
        }

        if (editorAction == 'edit') {
            for (var i = 0, l = fields.length ; i < l ; i++) {
                var e = fields[i];
                if (existingFields.indexOf(e.keyName) == -1) {
                    editorFields.push({
                        'name': e.keyName,
                        'type': 'hidden'
                    });
                    existingFields.push(e.keyName);
                }
            }
        }

        if (editorAction == 'create' || editorAction == 'edit') {
            for (var i = 0, l = fields.length ; i < l ; i++) {
                var e = fields[i];
                if (e.dataType === 'ID' || e.dataType === 'Reference') {
                    var hiddenFieldName = helper.getHiddenIdFieldName(e);
                    editorFields.push({
                        'name': hiddenFieldName,
                        'type': 'hidden',
                        'data': e.name,
                        'def': e.defaultValue
                    });
                    existingFields.push(hiddenFieldName);
                }
            }
        }

        return editorFields;
    },

    generateOrders : function(fields, hideFields, orders) {
        var shownFields = fields.filter(function(e) {
            return hideFields.indexOf(e.name) == -1
        }).map(function(e) {
            return e.name
        });

        return orders.map(function(e) {
            return [shownFields.indexOf(e.col), e.order || 'asc']
        });
    },

    generateColumns : function(cmp, fields, hideFields, style, fieldArray, labelArray, booleansExist) {
        var helper = this;
        var removeLookupHyperlinks = cmp.get('v.removeLookupHyperlinks');

        return fields.filter(function(e) {
            return hideFields.indexOf(e.name) == -1
        }).map(function(e) {
            return {
                data: e.name,
                title: labelArray[fieldArray.indexOf(e.name)] || e.label,
                defaultContent: '',
                orderDataType: booleansExist && e.dataType === 'Boolean' ? "dom-checkbox" : undefined,
                render: function(data, type, row, meta) {
                    if (e.dataType === 'Date') {
                        return '<span class="ro">' +
                                   (data ? moment(data).format('M/D/YYYY') : '') +
                               '</span>';
                    }
                    if (e.dataType === 'DateTime') {
                        return '<span class="ro">' +
                                   (data ? moment(data).format('M/D/YYYY h:mmA') : '') +
                               '</span>';
                    }
                    if (e.dataType === 'Address') {
                        return '<span class="ro">' +
                                   (data ? data : '') +
                               '</span>';
                    }
                    if (e.dataType === 'Boolean') {
                        return '<span class="ro' + (data === true ? ' checked' : '') + '">' +
                                   (style == 'SLDS'
                                       ? '<label class="slds-checkbox">' +
                                             '<input type="checkbox" class="pointer-events-none" readonly ' +
                                             (data === true ? 'checked="checked"' : '') + ' />' +
                                             '<span class="slds-checkbox--faux"></span>' +
                                         '</label>'
                                       : '<img src="/img/checkbox_' + (data === true ? 'checked' : 'unchecked') + '.gif" />'
                                    ) +
                               '</span>';
                    }
                    if (e.dataType === 'Currency') {
                        return '<span class="ro">' +
                                   //(data ? '$' + helper.formatNumber(data, e.scale) : '') +
                                   '$' + helper.formatNumber(data || 0, e.scale) +
                               '</span>';
                    }
                    if (e.dataType === 'ID') {
                        if (data && !helper.getRelationshipName(row, e)) {
                            helper.displayError(cmp, 'Cannot display Name for ' + e.label + ' because ' + e.relationshipName + ' was not queried');
                        }
                        return '<span class="ro">' +
                                   (data
                                        ? (!removeLookupHyperlinks ? '<a href="/' + data + '">' : '') +
                                          helper.getRelationshipName(row, e) +
                                          (!removeLookupHyperlinks ? '</a>' : '')
                                        : ''
                                    ) +
                               '</span>';
                    }
                    if (e.dataType === 'Reference') {
                        if (data && !helper.getRelationshipName(row, e)) {
                            helper.displayError(cmp, 'Cannot display Name for ' + e.label + ' because ' + e.relationshipName + ' was not queried');
                        }
                        return '<span class="ro">' +
                                   (data
                                        ? (!removeLookupHyperlinks ? '<a href="/' + data + '">' : '') +
                                          helper.getRelationshipName(row, e) +
                                          (!removeLookupHyperlinks ? '</a>' : '')
                                        : ''
                                    ) +
                               '</span>';
                    }
                    if (e.dataType === 'Double') {
                        return '<span class="ro">' +
                                   //(data ? helper.formatNumber(data, e.scale) : '') +
                                   helper.formatNumber(data || 0, e.scale) +
                               '</span>';
                    }
                    if (e.dataType === 'Integer') {
                        return '<span class="ro">' +
                                   //(data ? helper.formatNumber(data, e.scale) : '') +
                                   helper.formatNumber(data || 0, e.scale) +
                               '</span>';
                    }
                    if (e.dataType === 'Email') {
                        return '<span class="ro">' +
                                   (data ? '<a href="mailto:' + data + '">' + data + '</a>' : '') +
                               '</span>';
                    }
                    if (e.dataType === 'Percent') {
                        return '<span class="ro">' +
                                   (data ? helper.formatNumber(data, e.scale) + '%' : '') +
                               '</span>';
                    }
                    if (e.dataType === 'Phone') {
                        return '<span class="ro">' +
                                   (data ? data : '') +
                               '</span>';
                    }
                    if (e.dataType === 'Picklist') {
                        return '<span class="ro">' +
                                   (data ? data : '') +
                               '</span>';
                    }
                    if (e.dataType === 'MultiPicklist') {
                        return '<span class="ro">' +
                                   (data ? data : '') +
                               '</span>';
                    }
                    if (e.dataType === 'URL') {
                        return '<span class="ro">' +
                                   (data ? '<a href="' + data + '">' + data + '</a>' : '') +
                               '</span>';
                    }
                    if (e.dataType === 'TextArea') {
                        return '<span class="ro">' +
                                   (data ? data.replace(/\n/g, '<br />') : '') +
                               '</span>';
                    }
                    if (e.dataType === 'String') {
                        return '<span class="ro">' +
                                   (data ? data : '') +
                               '</span>';
                    }
                }
            }
        });
    },

    createTypeahead : function(cmp, editor, objectName, field) {
        var helper = this;
        var apexClass = cmp.get('v.apexClass');

        var activeSearch = null;

        var idx = field.relationshipName.lastIndexOf('.');
        var nameField = idx == -1 ? field.relationshipName : field.relationshipName.substring(idx + 1);

        var $input = editor.field(field.name).input()
        var $wrapper = $input.parent();

        $input.typeahead(
            {
                hint: true,
                minLength: 3,
                highlight: true,
            },
            {
                name: 'genericDataset',
                displayKey: nameField,
                source: function(query, callback) {
                    if (activeSearch) clearTimeout(activeSearch);

                    activeSearch = window.setTimeout(
                        $A.getCallback(function() {
                            var action = cmp.get('c.queryLookupValues');
                            var paramObj = {
                                'objectName': objectName,
                                'fieldJSON': $A.util.json.encode(field),
                                'query': query,
                                'apexClass': apexClass
                            };
                            action.setParams(paramObj);
                            
                            action.setCallback(this, function(response) {
                                $input.removeClass('typeahead-spinner');
                                var state = response.getState();
                                activeSearch = null;

                                if (state === "SUCCESS") {
                                    var result = response.getReturnValue();
                                    if (result.error) {
                                        helper.displayError(cmp, result.error);
                                        return;
                                    }

                                    callback(result.records);
                                } else if (state === "ERROR") {
                                    var errorMessage = 'Unknown error';
                                    var errors = response.getError();
                                    if (errors && errors[0] && errors[0].message) {
                                        errorMessage = "Error message: " + errors[0].message;
                                    }
                                    helper.displayError(cmp, errorMessage);
                                }
                            });
                            
                            $A.run(function() {
                                $input.addClass('typeahead-spinner');
                                $A.enqueueAction(action); 
                            });
                        }), 500
                    );
                },
                templates: {
                    suggestion: function(row) {
                        return '<p>' + row[nameField] + '</p>';
                    }
                }
            }
        );

        $input.attr('placeholder', 'Type to search (min 3)');
        $input.bind('typeahead:selected', function(event, obj, dataset) {
            if (obj) {
                editor.field(helper.getHiddenIdFieldName(field)).val(obj.Id);
            }
        }); 
        $input.bind('typeahead:cursorchanged', function(event, obj, dataset) {
            $wrapper.find('.tt-dropdown-menu .tt-suggestion').css('background-color', '');
            $wrapper.find('.tt-dropdown-menu .tt-suggestion.tt-cursor').css('background-color', '#0097cf')[0].scrollIntoView(false);
        });
        $input.find('.tt-dropdown-menu').mouseover(function() {
            $wrapper.find('.tt-suggestion').css('background-color', '');
            $wrapper.find('.tt-suggestion.tt-cursor').css('background-color', '#0097cf');
        });
    },

    afterTableRender : function(cmp) {
        var globalId = cmp.getGlobalId();

        var caption = cmp.get('v.caption');
        if (caption && !$(document.getElementById(globalId + '_table')).find('caption').length) {
            $(document.getElementById(globalId + '_table')).prepend('<caption class="sr-only">' + caption + '</caption>');
        }

        $(document.getElementById(globalId + '_table')).find('thead th')
            .attr({'scope': 'col', 'role': 'columnheader'})
            .attr('id', function(i, val) {
                return globalId + '_tableHeader' + $(this).index();
            });
        $(document.getElementById(globalId + '_table')).find('tbody td')
            .attr({'tabindex': '0', 'role': 'gridcell'})
            .attr('aria-describedby', function(i, val) {
                return globalId + '_tableHeader' + $(this).index();
            });

        if (cmp.onCellDblClick) {
            $(document.getElementById(globalId + '_table')).find('tbody').on('dblclick', 'td', function() {
                var oTable = $(document.getElementById(globalId + '_table')).DataTable();
                cmp.onCellDblClick({
                    'cell': oTable.cell(this).node(),
                    'row': oTable.row(oTable.cell(this).index().row).data()
                });
            });
        }
        if (cmp.onCellKeyEnter) {
            $(document.getElementById(globalId + '_table')).find('tbody').on('keydown', 'td', function(event) {
                if (event.which == 13) {
                    var oTable = $(document.getElementById(globalId + '_table')).DataTable();
                    cmp.onCellKeyEnter({
                        'cell': oTable.cell(this).node(),
                        'row': oTable.row(oTable.cell(this).index().row).data()
                    });
                }
            });
        }
    },

    beforeStart : function(cmp) {
        if (cmp.get('v._isFirstRun')) {
            $.datetimepicker.setDateFormatter({
                parseDate: function (date, format) {
                    var d = moment(date, format);
                    return d.isValid() ? d.toDate() : false;
                },
                
                formatDate: function (date, format) {
                    return moment(date).format(format);
                }
            });

            cmp.set('v._isFirstRun', false);
            this.pullData(cmp);
        }
    },

    getIdFields : function(fieldInfo) {
        return fieldInfo.fields.filter(function(f) { return f.dataType === 'ID' || f.dataType === 'Reference' });
    },

    getDateFields : function(fieldInfo) {
        return fieldInfo.fields.filter(function(f) { return f.dataType === 'Date' });
    },

    generateDataTable : function(cmp, dataTableOptions, fieldInfo, fieldArray, labelArray) {
        var helper = this;
        var globalId = cmp.getGlobalId();

        var $table = $(document.getElementById(globalId + '_table'));
        var canCreate = cmp.get('v.canCreate');
        var canEdit = cmp.get('v.canEdit');
        var canRemove = cmp.get('v.canRemove');
        var standardButtonsLabels = cmp.get('v.standardButtonsLabels');
        var eventButtons = cmp.get('v.eventButtons');
        var objectName = fieldInfo.objectName;
        var objectLabel = fieldInfo.objectLabel;
        var apexClass = cmp.get('v.apexClass');
        var style = cmp.get('v.style');

        var editorActions = [];
        if (canCreate) editorActions.push('create');
        if (canEdit) editorActions.push('edit');
        if (canRemove) editorActions.push('remove');
        
        var selectableButtons = helper.getSelectableButtons(eventButtons);
        if (canEdit || canRemove || selectableButtons.length) {
            $.extend(dataTableOptions, {
                'select': true
            });
        }

        var oTable = $table.DataTable(dataTableOptions);
        $table.wrap('<div style="overflow-x: auto; width: 100%;"></div>');

        var buttonsArray = [];

        if (editorActions.length) {
            var editorArray = [];

            for (var i = 0, l = editorActions.length ; i < l ; i++) {
                var editorOptions = {
                    'ajax': function (method, url, data, success, error) {
                        var idFields = helper.getIdFields(fieldInfo);
                        if (idFields.length && data.data) {
                            idFields.forEach(function(f) {
                                var hiddenIdFieldName = helper.getHiddenIdFieldName(f);
                                Object.keys(data.data).forEach(function(k) {
                                    data.data[k][f.name] = data.data[k][hiddenIdFieldName];
                                    delete data.data[k][hiddenIdFieldName];
                                });
                            });
                        }

                        var dateFields = helper.getDateFields(fieldInfo);
                        if (dateFields.length && data.data) {
                            dateFields.forEach(function(f) {
                                Object.keys(data.data).forEach(function(k) {
                                    if (data.data[k][f.name] === '') {
                                        data.data[k][f.name] = null;
                                    }
                                });
                            });
                        }

                        var action = cmp.get('c.processRows');
                        var paramObj = {
                            'action': data.action,
                            'rowsJSON': $A.util.json.encode(data.data),
                            'fieldInfoJSON': $A.util.json.encode(fieldInfo),
                            'objectName': objectName,
                            'apexClass': apexClass
                        };
                        action.setParams(paramObj);

                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var result = response.getReturnValue();
                                if (result.error) {
                                    helper.displayError(cmp, result.error);
                                    error(result);
                                    return;
                                }
                                if (result.fieldErrors) {
                                    error(result);
                                    return;
                                }

                                success(result);
                            }
                            else if (state === "ERROR") {
                                var errorMessage = 'Unknown error';
                                var errors = response.getError();
                                if (errors && errors[0] && errors[0].message) {
                                    errorMessage = "Error message: " + errors[0].message;
                                }
                                helper.displayError(cmp, errorMessage);
                            }
                        });
                        $A.run(function() {
                            $A.enqueueAction(action);
                        });
                    },
                    'table': $table,
                    'idSrc': fieldInfo.keyField,
                    'fields': helper.generateEditorFields(cmp, editorActions[i], fieldInfo, fieldArray, labelArray),
                    'formOptions': {
                        'main': {
                            'onReturn': 'none'
                        }
                    }
                };

                if (editorActions[i] == 'create') {
                    $.extend(editorOptions, {
                        'i18n': {
                            'create': {
                                'title': 'Create new ' + objectLabel
                            }
                        }
                    });
                }
                if (editorActions[i] == 'edit') {
                    $.extend(editorOptions, {
                        'i18n': {
                            'edit': {
                                'title': 'Update existing ' + objectLabel
                            }
                        }
                    });
                }
                if (editorActions[i] == 'remove') {
                    $.extend(editorOptions, {
                        'i18n': {
                            'remove': {
                                'title': 'Remove existing ' + objectLabel + '(s)',
                                'confirm': {
                                    _: 'Are you sure you want to remove %d ' + objectLabel + 's?',
                                    1: 'Are you sure you want to remove 1 ' + objectLabel + '?'
                                }
                            }
                        }
                    });
                }

                editorArray[i] = new $.fn.dataTable.Editor(editorOptions);

                if (style == 'SLDS') {
                    if (editorActions[i] == 'create') {
                        (function(editor) {
                            editor.on('initCreate', function(e) {
                                fieldInfo.fields.forEach(function(f) {
                                    editor.field(f.name).input().addClass('slds-input');
                                });
                            });
                        })(editorArray[i]);
                    }
                    if (editorActions[i] == 'edit') {
                        (function(editor) {
                            editor.on('initEdit', function(e) {
                                fieldInfo.fields.forEach(function(f) {
                                    editor.field(f.name).input().addClass('slds-input');
                                });
                            });
                        })(editorArray[i]);
                    }
                }

                if (editorActions[i] == 'create' && fieldInfo.requiredFields.length) {
                    (function(editor) {
                        editor.on('preSubmit', function(e, o, action) {
                            fieldInfo.requiredFields.forEach(function(requiredField) {
                                var editorField = editor.field(requiredField.name);
                                if (!editorField.val()) {
                                    editorField.error(requiredField.name + ' is a required field; you must enter a value');
                                }
                            });
                            if (this.inError()) {
                                return false;
                            }
                        });
                    })(editorArray[i]);
                }

                var idFields = helper.getIdFields(fieldInfo);
                if (idFields.length && (editorActions[i] == 'create' || editorActions[i] == 'edit')) {
                    (function(editor) {
                        editor.on('open', function(e, mode, action) {
                            idFields.forEach(function(f) {
                                //editor.field(f.name).input().data('id', editor.field('_hiddenID_' + f.name).val());
                                helper.createTypeahead(cmp, editor, fieldInfo.objectName, f);
                            });
                        }).on('close', function(e) {
                            idFields.forEach(function(f) {
                                editor.field(f.name).input().typeahead('destroy');
                            });
                        });
                    })(editorArray[i]);
                }

                buttonsArray[i] = {
                    'extend': editorActions[i],
                    'editor': editorArray[i]
                };
                if (standardButtonsLabels && standardButtonsLabels[editorActions[i]]) {
                    $.extend(buttonsArray[i], {
                        'text': standardButtonsLabels[editorActions[i]]
                    });
                }
            }
        }

        for (var i = 0, l = eventButtons.length ; i < l ; i++) {
            (function(eventButton) {
                buttonsArray.push({
                    'text': eventButton.label,
                    'enabled': !eventButton.select,
                    'className': (eventButton.select ? 'selectableButton' : undefined),
                    'action': function ( e, dt, node, config ) {
                        var data = '';

                        if (eventButton.send == 'row') {
                            var selRow = oTable.rows({
                                'selected': true
                                //,'page': 'current'
                            });
                            data = selRow.data()['0'];
                        }

                        var myEvent = $A.get("e.c:SalesforceDataTablesEvent");
                        myEvent.setParams({
                            'message': eventButton.label,
                            'data': data
                        });
                        myEvent.fire();
                    }
                });
            })(eventButtons[i]);
        }

        if (buttonsArray.length) {
            var buttons = new $.fn.dataTable.Buttons(oTable, {
                'buttons': buttonsArray
            });

            oTable.buttons().container().appendTo($(oTable.table().container()).find('.dt-bottom-row'));

            if (selectableButtons.length) {
                oTable.on('select', function( e, dt, type, indexes ) {
                    helper.onRowSelectToggle(cmp, oTable, indexes, true);
                } ).on('deselect', function( e, dt, type, indexes ) {
                    helper.onRowSelectToggle(cmp, oTable, indexes, false);
                } );
            }
        } else {
            //$('<div/>').addClass('dt-buttons')/*.css('height', '40px')*/.appendTo($(oTable.table().container()).find('.dt-bottom-row'));
        }
    },

    onRowSelectToggle : function(cmp, oTable, indexes, selected) {
        var selectedRows = oTable.rows( { selected: true } ).count();
        oTable.buttons('.selectableButton').enable(selectedRows === 1);
        if (cmp.onRowSelectToggle) {
            var row = oTable.rows(indexes).data();
            row.selected = selected;
            cmp.onRowSelectToggle({
                'row': row,
                'buttons': oTable.buttons().nodes()
            });
        }
    },

    pullData : function(cmp) {
        var helper = this;
        var globalId = cmp.getGlobalId();

        var apexClass = cmp.get('v.apexClass');
        var objectName = cmp.get('v.objectName');
        var fieldList = cmp.get('v.fieldList').replace(/, /g, ',');

        if (!apexClass && (!objectName || !fieldList)) {
            helper.displayError(cmp, 'You need to set either the apexClass attribute or both the objectName and fieldList attributes.<br />' +
                                     'Please provide a value and try again.');
            return;
        }
        
        var hideFields = cmp.get('v.hideFields').replace(/, /g, ',').split(',');
        var whereClause = cmp.get('v.whereClause');
        var orders = cmp.get('v.orders');
        var enhanced = cmp.get('v.enhanced');
        var labels = cmp.get('v.labels');
        var caption = cmp.get('v.caption');
        var style = cmp.get('v.style');
        var pageLength = cmp.get('v.pageLength');

        var fieldArray = fieldList.split(',');
        var labelArray = labels ? labels.replace(/, /g, ',').split(',') : [];

        var defaults = cmp.get('v.defaults');
        var defaultFields = Object.keys(defaults);
        if (!apexClass && defaultFields.length) {
            for (var i = 0, l = defaultFields.length ; i < l ; i++) {
                if (fieldArray.indexOf(defaultFields[i]) == -1) {
                    helper.displayError(cmp, 'You provided a default value for a field named <strong>' + defaultFields[i] + '</strong>' +
                                             ' but that field was not included in <strong>fieldList</strong>');
                    return;
                }
            }
        }

        if (style == 'SLDS') {
            $.fn.dataTableExt.oStdClasses.sWrapper = 'dataTables_wrapper'; // font-size-085
            $.fn.dataTableExt.oStdClasses.sTable = 'dataTable slds-table slds-table--bordered';
            $.fn.dataTableExt.oStdClasses.sSortable = 'slds-is-sortable sorting';
            $.fn.dataTableExt.oStdClasses.sSortAsc = 'slds-is-sortable sorting_asc';
            $.fn.dataTableExt.oStdClasses.sSortDesc = 'slds-is-sortable sorting_desc';
            $.fn.dataTableExt.oStdClasses.sStripeEven = 'slds-hint-parent';
            $.fn.dataTableExt.oStdClasses.sStripeOdd = 'slds-hint-parent';
            $.fn.dataTableExt.oStdClasses.sLength = 'dataTables_length margin-bottom-10';
            $.fn.dataTableExt.oStdClasses.sLengthSelect = 'slds-select width-auto';
            $.fn.dataTableExt.oStdClasses.sFilter = 'dataTables_filter margin-bottom-10';
            $.fn.dataTableExt.oStdClasses.sFilterInput = 'slds-input width-auto';
            $.fn.dataTableExt.oStdClasses.sPageButton = 'slds-button slds-button--neutral';
            $.fn.dataTableExt.oStdClasses.sPageButtonActive = 'slds-button slds-button--brand';
            $.fn.dataTableExt.oStdClasses.sPagePrevious = 'slds-button slds-button--neutral previous';
            $.fn.dataTableExt.oStdClasses.sPageNext = 'slds-button slds-button--neutral next';
            $.fn.dataTableExt.oStdClasses.sPaging = 'dataTables_paginate paging_';
            $.fn.dataTableExt.oStdClasses.sInfo = 'dataTables_info';

            if ($.fn.dataTable.Editor) {
                $.extend( true, $.fn.dataTable.Editor.classes, {
                    "wrapper": "DTE slds",
                    "form": {
                        "button": "slds-button slds-button--brand",
                        "buttons": "DTE_Form_Buttons slds-text-align--right"
                    }
                } );
            }
        }

        var pleaseWaitString = '<div class="pleaseWaitWrapper">' +
                                   '<img src="/img/loading32.gif" alt="Loading" style="vertical-align: middle;"/>' +
                                   '<br />Please wait...' +
                               '</div>';
        var dataTableOptions = {
            'drawCallback': function(settings) {
                helper.afterTableRender(cmp);
            },
            'paging': true,
            'pageLength': pageLength,
            'ordering': true,
            'info': true,
            'processing': true,
            'language': {
                'loadingRecords': pleaseWaitString,
                'processing': pleaseWaitString
            },
            'dom': 'lfrt<"dt-bottom-row"ip>'
        };

        if (enhanced) {
            var action = cmp.get('c.queryFieldInfo');
            action.setParams({
                objectName: objectName,
                fieldList: fieldList,
                defaultsJSON: $A.util.json.encode(defaults)
            });
            action.setCallback(this, function(response) {
                $(document.getElementById(globalId + '_processing')).remove();

                var state = response.getState();
                if (state === "SUCCESS") {
                    (function(){
                        var fieldInfo = response.getReturnValue();
                        if (fieldInfo.error) {
                            helper.displayError(cmp, fieldInfo.error);
                            return;
                        }

                        var fields = fieldInfo.fields;
                        objectName = fieldInfo.objectName;

                        for (var i = 0, columns = [], booleansExist = false; i < fields.length; i++) {
                            if (fields[i].dataType == 'Address') {
                                helper.displayError(cmp, fields[i].name + ' is an Address field.' +
                                                         ' Address fields are currently not supported.' +
                                                         ' Please remove it from your query and try again.');
                                return;
                            }
                            if (fields[i].dataType == 'Location') {
                                helper.displayError(cmp, fields[i].name + ' is an Geolocation field.' +
                                                         ' Geolocation fields are currently not supported.' +
                                                         ' Please remove it from your query and try again.');
                                return;
                            }
                            if (!booleansExist && fields[i].dataType == 'Boolean') {
                                booleansExist = true;
                            }

                            columns.push({
                                'data': fields[i].name
                            });
                        }

                        if (booleansExist) {
                            $.fn.dataTableExt.order['dom-checkbox'] = function(settings, col) {
                                return this.api().column(col, {order:'index'}).nodes().map(function(td, i) {
                                    return $('.ro.checked', td).length ? '1' : '0';
                                });
                            }
                        }

                        var allKeys, order, search, gsearch, recordsTotal, recordsFiltered;

                        $.extend(dataTableOptions, {
                            'rowCallback': function(row, data, index) {
                                row.id = data[fieldInfo.keyField];
                            },
                            'columns': helper.generateColumns(cmp, fieldInfo.fields, hideFields, style, fieldArray, labelArray, booleansExist),
                            'serverSide': true,
                            'ajax': function (data, callback, settings) {
                                var cOrder = data.order, cSearch = data.columns.map(function(e) { return e.search }), cGsearch = data.search.value;

                                var keys = [];
                                if (JSON.stringify(cOrder) !== JSON.stringify(order) ||
                                    JSON.stringify(cSearch) !== JSON.stringify(search) ||
                                    JSON.stringify(cGsearch) !== JSON.stringify(gsearch))
                                {
                                    order = cOrder;
                                    search = cSearch;
                                    gsearch = cGsearch;
                                } else {
                                    keys = allKeys.slice(data.start, data.start + data.length);
                                }

                                var action = cmp.get('c.getRecordsEnhanced');
                                action.setParams({
                                    fieldInfoJSON: $A.util.json.encode(fieldInfo),
                                    requestJSON: $A.util.json.encode(data),
                                    objectName: objectName,
                                    soqlFieldsJSON: $A.util.json.encode(fieldArray),
                                    apexClass: apexClass,
                                    whereClause: whereClause,
                                    keysJSON: $A.util.json.encode(keys),
                                    recordsTotal: recordsTotal,
                                    recordsFiltered: recordsFiltered
                                });

                                action.setCallback(this, function(response) {
                                    var state = response.getState();

                                    if (state === "SUCCESS") {
                                        var result = response.getReturnValue();
                                        if (result.error) {
                                            helper.displayError(cmp, result.error);
                                            return;
                                        }

                                        if (result.allKeys) {
                                            allKeys = result.allKeys;
                                            recordsTotal = result.recordsTotal;
                                            recordsFiltered = result.recordsFiltered;
                                        }

                                        callback(result);
                                    } else if (state === "ERROR") {
                                        var errorMessage = 'Unknown error';
                                        var errors = response.getError();
                                        if (errors && errors[0] && errors[0].message) {
                                            errorMessage = "Error message: " + errors[0].message;
                                        }
                                        helper.displayError(cmp, errorMessage);
                                    }
                                });
                                $A.run(function() {
                                    $A.enqueueAction(action);
                                });
                            }
                        });
                        
                        if (orders.length) {
                            $.extend(dataTableOptions, {
                                'order': helper.generateOrders(fieldInfo.fields, hideFields, orders)
                            });
                        }
                        console.log(dataTableOptions);
                        helper.generateDataTable(cmp, dataTableOptions, fieldInfo, fieldArray, labelArray);
                    })();
                } else if (state === "ERROR") {
                    var errorMessage = 'Unknown error';
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        errorMessage = "Error message: " + errors[0].message;
                    }
                    helper.displayError(cmp, errorMessage);
                }
            });
            
            $A.run(function() {
                $A.enqueueAction(action);
            });
        } else {
            var action = cmp.get('c.getRecordsStandard');
            action.setParams({
                objectName: objectName,
                fieldList: fieldList,
                whereClause: whereClause,
                apexClass: apexClass,
                defaultsJSON: $A.util.json.encode(defaults)
            });
            action.setCallback(this, function(response) {
                $(document.getElementById(globalId + '_processing')).remove();
                var state = response.getState();
                if (state === "SUCCESS") {
                    (function(){
                        var result = response.getReturnValue();
                        if (result.error) {
                            helper.displayError(cmp, result.error);
                            return;
                        }
                        var fieldInfo = result.fieldInfo;

                        for (var i = 0, booleansExist = false; i < fieldInfo.fields.length; i++) {
                            if (fieldInfo.fields[i].dataType == 'Boolean') {
                                booleansExist = true;
                                break;
                            }
                        }

                        if (booleansExist) {
                            $.fn.dataTableExt.order['dom-checkbox'] = function(settings, col) {
                                return this.api().column(col, {order:'index'}).nodes().map(function(td, i) {
                                    return $('.ro.checked', td).length ? '1' : '0';
                                });
                            }
                        }

                        $.extend(dataTableOptions, {
                            'rowCallback': function(row, data, index) {
                                row.id = data[fieldInfo.keyField];
                            },
                            'columns': helper.generateColumns(cmp, fieldInfo.fields, hideFields, style, fieldArray, labelArray, booleansExist),
                            'data': result.records
                        });

                        if (orders.length) {
                            $.extend(dataTableOptions, {
                                'order': helper.generateOrders(fieldInfo.fields, hideFields, orders)
                            });
                        }

                        helper.generateDataTable(cmp, dataTableOptions, fieldInfo, fieldArray, labelArray);
                    })();
                } else if (state === "ERROR") {
                    var errorMessage = 'Unknown error';
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        errorMessage = "Error message: " + errors[0].message;
                    }
                    helper.displayError(cmp, errorMessage);
                }
            });
            $A.run(function() {
                $A.enqueueAction(action);
            });

        }
    }
})