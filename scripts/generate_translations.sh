scripts/submission_translate.sh 7 ja-en-2_step_400000.pt ja en 777
scripts/submission_translate.sh 7 ja-en_step_300000.pt ja en 777
scripts/submission_translate_transformer_base.sh 7 transformer_base_step_50000.pt ja en 777
scripts/submission_translate_ensemble.sh 7 ja-en_step_260000.pt ja en 777 ja-en_step_290000.pt ja-en_step_300000.pt
scripts/submission_translate_ensemble.sh 7 ja-en-2_step_400000.pt ja en 777 ja-en-2_step_420000.pt ja-en-2_step_460000.pt
scripts/submission_translate.sh 7 en-ja_step_300000.pt en ja 777
scripts/submission_translate.sh 7 en-ja-bt-pofo-02_step_170000.pt en ja 777
scripts/submission_translate_ensemble.sh 7 en-ja_step_300000.pt en ja 777 en-ja_step_290000.pt en-ja_step_260000.pt
scripts/submission_translate_ensemble.sh 7 en-ja-bt-pofo-02_step_170000.pt en ja 777 en-ja-bt-pofo-02_step_130000.pt en-ja-bt-pofo-02_step_160000.pt
