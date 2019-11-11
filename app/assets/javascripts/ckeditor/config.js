if (typeof(CKEDITOR) != 'undefined') {
  CKEDITOR.editorConfig = function (config) {
    // ... other configuration ...

    config.uiColor = "#E9E9E9";
    config.toolbarGroups = [
      { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
      { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
      { name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
      { name: 'forms', groups: [ 'forms' ] },
      '/',
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
      { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
      { name: 'links', groups: [ 'links' ] },
      { name: 'insert', groups: [ 'insert' ] },
      '/',
      { name: 'styles', groups: [ 'styles' ] },
      { name: 'colors', groups: [ 'colors' ] },
      { name: 'tools', groups: [ 'tools' ] },
      { name: 'others', groups: [ 'others' ] },
      '/',
      '/',
      { name: 'about', groups: [ 'about' ] }
    ];
    config.placeholder = 'some value';

    config.removeButtons = 'Source,Save,NewPage,Preview,Print,Templates,Cut,Copy,Paste,PasteText,PasteFromWord,Undo,Redo,Replace,Find,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,CopyFormatting,RemoveFormat,Outdent,Indent,Blockquote,CreateDiv,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock,BidiLtr,BidiRtl,Language,Link,Unlink,Anchor,Flash,SpecialChar,PageBreak,Iframe,Format,FontSize,TextColor,BGColor,ShowBlocks,Maximize,About,Font,Styles';

    // ... rest of the original config.js  ...
  }

  $(document).ready( function() {
  	var editor = CKEDITOR.instances["product-editor"];

  	editor.on( 'required', function( evt ) {
      	alert( 'Description is required.' );
  	});
  });
}