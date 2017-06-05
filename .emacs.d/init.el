;;; for Debug ~/.emacs.d/init.el ;;;
;; (setq stack-trace-on-error t)
;; (setq debug-on-error)

; GUI から起動された Emacs の path が正しく渡らないための設定
; 下に記述したものが PATH の先頭に追加される
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/bin"
              "/opt/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
; PATH と exec-path に同じ物を追加
(when (and (file-exists-p dir) (not (member dir exec-path)))
  (setenv "PATH" (concat dir ":" (getenv "PATH")))
  (setq exec-path (append (list dir) exec-path))))

;; ;;; el-get ;;;
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
(global-set-key "\C-z" 'undo)
(global-set-key "\C-h" 'delete-backward-char)
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
  (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlomarugo")
  (set-fontset-font "fontset-menlomarugo"
                    'unicode
                    (font-spec :family "Hiragino Maru Gothic ProN" :size 14)
                    nil
                    'append)
  (add-to-list 'default-frame-alist '(font . "fontset-menlomarugo"))
  ) (menu-bar-mode -1)
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
;; (setq-default truncate-lines t)
;; (setq truncate-partial-width-windows t)

;;; 自動でスペルチェック
;; M-x ispell-buffer で buffer 全体をスペルチェック
;; M-x ispell-region で region をスペルチェック
(setq ispell-program-name "/opt/local/bin/ispell")
(setq flyspell-issue-message-flag nil)
(setq ispell-dictionary "american")
;; flyspell text-mode
(add-hook
 'text-mode-hook 'flyspell-mode)
;; flyspell program mode
(add-hook
 'prog-mode-hook 'flyspell-prog-mode)



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

;;; CUDA
(setq auto-mode-alist
    (cons (cons "\\.cu$" 'c++-mode) auto-mode-alist))

;;; GDB ;;;
(add-hook 'gdb-mode-hook
          '(lambda ()
             (setq gdb-many-windows t)
             (setq gud-gdb-command-name "ggdb -i=mi")
             (local-set-key "\C-p" 'comint-previous-input)
             (local-set-key "\C-n" 'comint-next-input)
             ))
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






;;; flycheck : 自動でチェック ;;;
;; melpa に登録されたレポジトリも M-x package-install 可能にする
;; flycheck は C-c ! l で error 一覧表示
;; flycheck は C-c ! p で `
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elpa/flycheck-20151026.342")
(add-to-list 'load-path "~/.emacs.d/elpa/dash-20151021.113")
(add-to-list 'load-path "~/.emacs.d/elpa/subr+-20150104.1655")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; 日本語で error message が出る場合の自作 flycheck
(add-hook 'c-mode-common-hook 'flycheck-mode)
(defmacro flycheck-define-clike-checker (name command modes)
  `(flycheck-define-checker ,(intern (format "%s" name))
     ,(format "A %s checker using %s" name (car command))
     :command (,@command source-inplace)
     :error-patterns
     ((warning line-start (file-name) ":" line ":" column ": 警告:" (message) line-end)
      (error line-start (file-name) ":" line ":" column ": エラー:" (message) line-end))
     :modes ',modes))
;; (flycheck-define-clike-checker c-gcc-ja
;;              ("gcc" "-fsyntax-only" "-Wall" "-Wextra")
;;              c-mode)
;; (add-to-list 'flycheck-checkers 'c-gcc-ja)
;; (flycheck-define-clike-checker c++-g++-ja
;;              ("g++" "-fsyntax-only" "-Wall" "-Wextra" "-std=c++11")
;;              c++-mode)
;; (add-to-list 'flycheck-checkers 'c++-g++-ja)


;; error message を popup で出す
(add-to-list 'load-path "~/.emacs.d/elpa/flycheck-pos-tip-20140606.510")
(add-to-list 'load-path "~/.emacs.d/elpa/popup-20150626.711")
(eval-after-load 'flycheck
  '(custom-set-variables
   '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))
;;; end of flycheck ;;;



;;; 補完 auto-complete 系 ;;;
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete")
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete-clang")
(add-to-list 'load-path "~/.emacs.d/el-get/fuzzy")
(add-to-list 'load-path "~/.emacs.d/el-get/popup")
(add-to-list 'load-path "~/.emacs.d/el-get/yasnippet")
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete-yasnippet")

; 自分で設定した特定関数を key に合わせて tab で展開
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(ac-config-default)
; 自動で補完を開始しない
(setq ac-auto-start nil)
; TAB を trigger にする
(ac-set-trigger-key "TAB")
; delay を無くす
(setq ac-quick-help-delay 0)
;; ; yasnippet の補完
 (add-hook 'yasnippet-mode-hook
 '(lambda ()
 (add-to-list 'ac-sources 'auto-complete-yasnippet)
 )
; C-p C-n で候補移動
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)


;;; auto complete clang mode ;;;
(require 'auto-complete-clang)

(defun my-ac-cc-mode-setup ()
  ;;tなら自動で補完画面がでる．nilなら補完キーによって出る
  (setq ac-auto-start nil)
  (setq ac-clang-prefix-header "./stdafx.pch")
  (setq ac-clang-flags '("-w" "-ferror-limit" "1"))
  (setq ac-sources (append '(ac-source-clang
			     ;;ac-source-yasnippet
			     ac-source-gtags)
			   ac-sources)))

(defun my-ac-config ()
  (global-set-key "\M-/" 'ac-start)
  ;; C-n/C-p で候補を選択
  (define-key ac-complete-mode-map "\C-n" 'ac-next)
  (define-key ac-complete-mode-map "\C-p" 'ac-previous)

  (setq-default ac-sources '(ac-source-abbrev
			     ac-source-dictionary
			     ac-source-words-in-same-mode-buffers))
  (add-hook 'c++-mode-hook 'ac-cc-mode-setup)
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)
;;pathのプリコンパイルヘッダ作りかた
;;clang++ -cc1 -emit-pch -x c++-header ./hoge.h -o stdafx.pch




;;; python用 ;;;
(add-to-list 'load-path "~/.emacs.d/el-get/python")
(add-to-list 'load-path "~/.emacs.d/el-get/python-mode")
(add-to-list 'load-path "~/.emacs.d/el-get/pymacs")
(add-to-list 'load-path "~/.emacs.d/el-get/pycomplete")
(add-to-list 'load-path "~/.emacs.d/el-get/ac-python")
(autoload 'python-mode "python-mode" "Major mode for editing Python programs" t)
(autoload 'py-shell "python-mode" "Python shell" t)
(setq auto-mode-alist (cons '("\\.py\\'" . python-mode) auto-mode-alist))
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs"
'(add-to-list 'pymacs-load-path "~/.emacs.d/el-get/pycomplete"))
(add-hook 'python-mode-hook '(lambda ()
(require 'pycomplete)
(add-to-list 'ac-sources 'ac-python)
;(setq indent-tabs-mode nil)
))
;; ;; python 最強の補完 jedi を active に
;; 断念、次回挑戦したい auto-complete-mode との衝突が原因か
;; (add-to-list 'load-path "~/.emacs.d/el-get/jedi")
;; (add-to-list 'load-path "~/.emacs.d/el-get/")
;; (add-to-list 'load-path "~/.emacs.d/el-get/epc")
;; (add-to-list 'load-path "~/.emacs.d/el-get/ctable")
;; (add-to-list 'load-path "~/.emacs.d/el-get/deferred")
;; (setq jedi:server-command '("~/.emacs.d/el-get/jedi/jedipcserver.py"))
;; (require jedi)
;; (setq jedi:server-command '("~/.emacs.d/el-get/jedi/jedipcserver.py"))
;; (add-hook 'python-mode-hook 'jedi:ac-setup)
;; (setq jedi:complete-on-dot t); optional
;; (define-key python-mode-map (kbd "<C-tab>") 'jedi:complete)



;;; index highlight ;;;
(add-to-list 'load-path "~/.emacs.d/el-get/highlight-indentation")
(require 'highlight-indentation)
(setq highlight-indentation-offset 2)
;;(set-face-background 'highlight-indentation-face "#90ee90")
(set-face-background 'highlight-indentation-face "#4b89d0")
;;(set-face-background 'highlight-indentation-current-column-face "#008b45")
(set-face-background 'highlight-indentation-current-column-face "#b22222")
(add-hook 'highlight-indentation-mode-hook 'highlight-indentation-current-column-mode)

(add-hook 'c++-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'c-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'python-mode-hook 'highlight-indentation-mode)
(add-hook 'text-mode-hook 'highlight-indentation-mode)
;;(add-hook 'prog-mode-hook 'highlight-indentation-mode)
(add-hook 'gdb-mode-hook 'highlight-indentation-mode)
(add-hook 'yatex-mode-hook 'highlight-indentation-mode)
;;(add-hook 'emacs-lisp-mode-hook 'highlight-indentation-mode)

;;; undo tree and hist
;; (add-to-list 'load-path "~/.emacs.d/el-get/undohist")
;; (add-to-list 'load-path "~/.emacs.d/el-get/undo-tree")
;; ; undo の履歴を buffer を閉じても保持する
;; (when (require 'undohist nil t)
;;   (undohist-initialize))
;; ; undo の樹形図を表示する C-x u
;; (when (require 'undo-tree nil t)
;;   (global-undo-tree-mode))


;; ;;; undo list の制限を拡張する
(setq undo-outer-limit 50000000)
