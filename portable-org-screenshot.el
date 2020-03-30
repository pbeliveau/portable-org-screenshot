;;; portable-org-screenshot.el --- screenshot to org buffer

;; Author: Philippe Beliveau
;; Keywords: screenshot emacs org-mode
;; Homepage: https://github.com/pbeliveau/portable-org-screenshot
;; Version: 0.2
;; Requirements: nircmdc.exe & irfanview – non-free software to copy to clipboard in windows.

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Simple package to capture a screenshot and insert it immediatly in the active
;; buffer. Detects whether you are on a Windows machine or Linux.
;;
;; Uses include irfanview for Windows and nircmdc.exe to paste to clipboard.
;; Uses grim and slurp for screenshots in sway-wm (wayland).
;; See grim: https://github.com/emersion/grim

(defun portable-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
      (concat
       org-directory "/img/"
        (concat
         (make-temp-name
          (concat (buffer-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png")))

  (if (eq system-type 'windows-nt)
      (shell-command (concat "irfanview.exe i_view64 /capture=4 /convert=" (replace-regexp-in-string "/" "\\" filename t t))))

    (if (eq system-type 'gnu/linux)
        (progn
          (setq region (concat "'" (shell-command-to-string "printf %s \"$(slurp)\"") "'"))
          (shell-command (concat "grim -g " region " " filename))))

  (setq varfilename
        (concat "../" (mapconcat 'identity (last (s-split "/" filename) 2) "/")))

  (insert (concat "[[file:" varfilename "]]"))
  (org-display-inline-images))

(provide 'portable-org-screenshot)
