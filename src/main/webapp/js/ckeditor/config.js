/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	config.language = 'ko';
	config.uiColor = '#EAEAEA';
	config.toolbar = [
			['Font', 'FontSize'],
			['TextColor', 'BGColor'],
			['Bold', 'Italic', 'Strike', 'Superscript', 'Subscript', 'Underline', 'RemoveFormat'],
			['Outdent', 'Indent'],
			['Find', 'Replace'],
			'/',		//툴바 단 구분
			['Image', 'Table' ,'SpecialChar', 'Smiley'],
			['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'],
			['Blockquote', 'NumberedList', 'BulletedList'],
			['Link', 'Unlink'],
			['Undo', 'Redo'],
			['Source']
	];	
	config.enterMode = CKEDITOR.ENTER_P;  // 엔터 모드
	config.shiftEnterMode = CKEDITOR.ENTER_P;

	// 기본 폰트 설정
	config.font_defaultLabel = '돋움';
	// 글꼴 추가하기
	config.font_names = '돋움; Nanum Gothic Coding; 맑은 고딕; 바탕; 궁서; 굴림체; 굴림; Quattrocento Sans;' + CKEDITOR.config.font_names;
	// 기본 폰트 크기 설정
	config.fontSize_defaultLabel = '12px';
	// 시작 시 포커스 설정
	config.startupFocus = false;
	// 기본적인 html 필터링
	config.allowedContent = true;
	// 업로드 파일 업로드 경로 (설정시 업로드 플러그인에 탭이 생김)
	config.filebrowserImageUploadUrl = '/file/imageUpload.do'; 

};
