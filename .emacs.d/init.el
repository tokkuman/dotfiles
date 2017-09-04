;;; el-get ;;;
;; M-x el-get-list-packages でパッケージのリストを表示、i を押して x でinstall
;; el-get インストール後のロードパスの用意
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; もし el-get がなければインストールを行う
(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (end-of-buffer)
       (eval-print-last-sexp)))))
(require 'el-get)


;;; 共通設定 ;;;
; 言語を日本語にする
(set-language-environment 'Japanese)
; UTF-8とする
(prefer-coding-system 'utf-8)
; 起動時の画面はいらない
(setq inhibit-startup-message t)
; scratchの初期メッセージ消去
(setq initial-scratch-message "")
;;括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#500")
;一行ずつスクロール;
(setq scroll-step 1)
;バックアップファイルを残さない
(setq make-backup-files nil)
;色指定を可能にする
(setq font-lock-maximum-decoration t)
; ignore pasting image to Emacs when copying from MS Word
;ペースト時に画像のペーストをしない
(setq yank-excluded-properties t)
;短形選択を有効にする
(cua-mode t)
(setq cua-enable-cua-keys nil) ;unenable default key
(define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)

;;; key bind ;;;
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-z" 'undo)
(global-set-key "\M-\C-h" 'backward-kill-word)
(global-set-key "\M-h" 'help-for-help)
(global-set-key "\M-g" 'goto-line)
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
(global-set-key "\C-]" 'find-tag)
(global-set-key "\C-t" 'pop-tag-mark)
(define-key minibuffer-local-completion-map "\C-p" 'previous-history-element)
(define-key minibuffer-local-completion-map "\C-n" 'next-history-element)
(load-library "term/bobcat") ;;; Backspace <-> DEL ;;;


;;; history ;;;
(savehist-mode 1) ;;; ミニバッファの履歴を保存する
(setq history-length 10000) ;;; 履歴数を大きくする
(recentf-mode)
(setq recentf-max-saved-items 10000) ;;; 最近開いたファイルを保存する数を増やす


;;; MacOS で emacs を開いた場合 ;;;
 (when (eq system-type 'darwin)
   ;;; Command keyをMetaに
   (setq ns-command-modifier 'meta))

 ;;; GUI版Emacs (emacs.app) の場合 ;;;
 (if window-system (progn ;progn は以下のフォームを逐次実行

   (custom-set-faces ;C-x 5 2 等で新しく Window を開いたときの設定
     '(default ((t (:background "gray10" :foreground "lightcyan"))))
     '(cursor (
            (((class color) (background dark )) (:background "lime green"))
            (((class color) (background light)) (:background "lime green"))
            (t ())
            )))
   ;; Master Display の設定
   (set-foreground-color "lightcyan")
   (set-background-color "gray10")
   (set-cursor-color "lime green")
   ;; 起動時のディスプレイサイズ変更(環境に応じて適宜変更)
   (set-frame-height (next-frame) 50)
   (set-frame-width (next-frame) 80)
   ;; メニューバーを隠す
   (tool-bar-mode -1)
   ;; デフォルトの透明度を設定する (80%)
   (add-to-list 'default-frame-alist '(alpha . 80))
   ;; カレントウィンドウの透明度を変更する (85%)
   (set-frame-parameter nil 'alpha 85)
   ;;; 画像ファイルを表示する
   (auto-image-file-mode t)
   ;;行番号表示
   (require 'linum)
   (global-linum-mode t)
 ;;  (set-face-attribute 'linum nil
                       :foreground "gray60"
                       :height 0.9)

   ;; Font
   ;; (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlomarugo")
   ;; (set-fontset-font "fontset-menlomarugo"
   ;;                   'unicode
   ;;                   (font-spec :family "Hiragino Maru Gothic ProN" :size 14)
   ;;                   nil
   ;;                   'append)
   ;; (add-to-list 'default-frame-alist '(font . "fontset-menlomarugo"))
   ;; ) (menu-bar-mode -1)
 )


;;; 環境設定 (共通設定2) ;;;
; version のコントロールをしない
(setq version-control nil)
; backup file の作成しない
(setq backup-inhibited t)
(setq create-lockfiles nil)
; auto save file を終了時に消去
(setq delete-auto-save-files t)
; beep 音を出さない
(setq visible-bell t)
; display line number
(line-number-mode t)
; display column number
(setq column-number-mode t)
; カーソルの点滅をやめる
(blink-cursor-mode 0)
; hilight copy region
(setq transient-mark-mode t)
; C-k で改行含めて kill
(setq kill-whole-line t)
; C-n で下に移動時に new-line しない
(setq next-line-add-newlines nil)
; tab ではなく space を使う
(setq-default indent-tabs-mode nil)
; tab 幅を 2 に設定
(setq-default tab-width 2)
; end of file ; narrowing を次回も有効にする
; C-x n で region を narrowing
; C-x p で page を narrowing
; C-x w で復帰
(put 'narrow-to-region 'disabled nil)
; function の上部に現在の関数名を表示
(which-function-mode 1)
; eval した結果を全部表示
(setq eval-expression-print-length nil)
; 行末のいらない space を強調する
(setq show-trailing-whitespace t)

;;; 補完
; 補完時に文字の大小を気にしない (全般)
(setq completion-ignore-case t)
; buffer 補完時に文字の大小を気にしない
(setq buffer-completion-ignore-case t)
; file名補完時に文字の大小を気にしない
(setq read-file-name-completion-ignore-case t)

;;; 検索
; 検索時には文字の大小を気にしない (全般)
(setq case-fold-search t)
; インクリメンタルサーチ (C-s) 時には文字の大小は気にしない
(setq isearch-case-fold-search t)

;;; 置換時に文字の大小を区別する
; なお query replace は M-%
(setq case-replace nil)

;;; ファイルの先頭に#!...があるファイルを保存すると実行権をつける
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; ;;; 画面右端で折り返さない
(setq-default truncate-lines t)
(setq truncate-partial-width-windows t)


;; c-mode や c++-mode など cc-mode ベースのモード共通の設定
(add-hook
 'c-mode-common-hook
 (lambda ()
   ;; BSDスタイルをベースにする
   (c-set-style "bsd")
   ;; スペースでインデントをする
   (setq indent-tabs-mode nil)
   ;; インデント幅を2にする
   (setq c-basic-offset 2)
   ;; CamelCaseの語でも単語単位に分解して編集する
   ;; EmacsFrameClass   => Emacs Frame Class
   (subword-mode 1)
;行末の不要なスペースを強調する;
  (setq show-trailing-whitespace t)
; コード折り畳みモード
  (hs-minor-mode 1)
;; key bind
  (define-key hs-minor-mode-map (kbd "\C-ch") 'hs-toggle-hiding)
  (define-key hs-minor-mode-map (kbd "\C-cl") 'hs-hide-level)
  (define-key hs-minor-mode-map (kbd "\C-co") 'hs-show-all)
  ))

; ヘッダファイルを c++ として開く
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))


;; emacs-lisp-modeでバッファーを開いたときに行う設定
(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   ;; スペースでインデントをする
   (setq indent-tabs-mode nil)
   ;行末の不要なスペースを強調する;
  (setq show-trailing-whitespace t)
  ))

;;; CUDA ;;;
(setq auto-mode-alist
    (cons (cons "\\.cu$" 'c++-mode) auto-mode-alist))

;;; GDB ;;;
;; (add-hook 'gdb-mode-hook
;;           '(lambda ()
;;              (setq gdb-many-windows t)
;;              (setq gud-gdb-command-name "ggdb -i=mi")
;;              (local-set-key "\C-p" 'comint-previous-input)
;;              (local-set-key "\C-n" 'comint-next-input)
;;              ))
;;; tex 関連
;;; YaTeX ;;;
(add-to-list 'load-path "~/.emacs.d/el-get/yatex")
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(add-hook 'yatex-mode-hook'(lambda ()(setq auto-fill-function nil)))

;;; Reftex-mode ;;;
;; 参考文献をciteするときに 'C-c [' で簡易に検索可能となる
(add-hook 'yatex-mode-hook 'turn-on-reftex)

;; Preview.app の使用
(setq dvi2-command "open -a Preview")
