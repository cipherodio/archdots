" ============================================================================
" Markdown callout highlights (pure Vim syntax)
" ============================================================================

" NOTE
syntax match markdownCalloutNote /\[!NOTE\]/ containedin=ALL
highlight default link markdownCalloutNote Identifier

" TIP
syntax match markdownCalloutTip /\[!TIP\]/ containedin=ALL
highlight default link markdownCalloutTip String

" IMPORTANT
syntax match markdownCalloutImportant /\[!IMPORTANT\]/ containedin=ALL
highlight default link markdownCalloutImportant Statement

" WARNING
syntax match markdownCalloutWarning /\[!WARNING\]/ containedin=ALL
highlight default link markdownCalloutWarning WarningMsg

" CAUTION
syntax match markdownCalloutCaution /\[!CAUTION\]/ containedin=ALL
highlight default link markdownCalloutCaution ErrorMsg
