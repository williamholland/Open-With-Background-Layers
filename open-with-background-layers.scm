(define (script-fu-open-with-black-layers filename)
  (let* ((image (car
                  (gimp-file-load RUN-NONINTERACTIVE filename filename)))
         (layer (car
                  (gimp-image-get-active-layer image)))
         (white-layer (car
                        (gimp-layer-new image
                                        (car (gimp-image-width image))
                                        (car (gimp-image-height image)) 
                                        RGB-IMAGE
                                        "White Background"
                                        100
                                        NORMAL-MODE))) 
         (black-layer (car
                        (gimp-layer-new image
                                        (car (gimp-image-width image))
                                        (car (gimp-image-height image)) 
                                        RGB-IMAGE
                                        "Black Background"
                                        100
                                        NORMAL-MODE))))
    (gimp-image-insert-layer image white-layer 0 -1)
    (gimp-drawable-fill white-layer WHITE-FILL)
    (gimp-image-lower-item-to-bottom image white-layer)
    (gimp-image-insert-layer image black-layer 0 -1)

    ; Store the old foreground color
    (let* ((old-fg-color (car (gimp-palette-get-foreground))))
      ; Set the foreground color to black
      (gimp-palette-set-foreground '(0 0 0))
      ; Fill the background layer with the new foreground color
      (gimp-drawable-fill black-layer FILL-FOREGROUND)
      ; Restore the old foreground color
      (gimp-palette-set-foreground old-fg-color))

    (gimp-image-lower-item-to-bottom image black-layer)

    (gimp-display-new image)
    (gimp-displays-flush)))

(script-fu-register
  "script-fu-open-with-black-layers"
  "Open With Background Layers"
  "When opening a file, create background layers under it automatically"
  "Will Holland (fiver.com/willholland)"
  ""
  "2023"
  ""

  ; define the GUI
  ;type  ;label  ;values
  SF-FILENAME "Image file" ""
)

(script-fu-menu-register
  "script-fu-open-with-black-layers"
  "<Image>/Plugins"
)
