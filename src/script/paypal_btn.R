

paypal_btn <- function(){
  
  wellPanel(
    
    p(img(src = "coffee-icon.png", style = "width: 25px; height : 25px;", ), "Offrez-moi un café :)"),
    br(),
    
    HTML(
      '<form action="https://www.paypal.com/donate" method="post" target="_top">
       <input type="hidden" name="hosted_button_id" value="27DR54XR9GEX4" />
       <input type="image" src="https://www.paypalobjects.com/fr_FR/FR/i/btn/btn_donate_LG.gif" border="0" name="submit" title="PayPal - The safer, easier way to pay online!" alt="Bouton Faites un don avec PayPal" />
       <img alt="" border="0" src="https://www.paypal.com/fr_FR/i/scr/pixel.gif" width="1" height="1" />
       </form>'),
    
    br(),
    p("Je suis freelance, votre soutien m'aide à rester indépendant et à développer de nouveaux outils."),
    
    a("LinkedIn", href="https://www.linkedin.com/in/philippeperet/")
  
  )
  
}


