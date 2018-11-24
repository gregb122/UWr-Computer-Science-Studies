function validateForm(){
    var acc_number = document.forms["formularz"]["account_number"].value;
    var pesel = document.forms["formularz"]["pesel"].value;
    var email = document.forms["formularz"]["email"].value;
    var daybirthdate = document.forms["formularz"]["birth_date_day"].value;
    var monthbirthdate = document.forms["formularz"]["birth_date_month"].value;
    var yearbirthdate = document.forms["formularz"]["birth_date_year"].value;
    if (!(validatePesel(pesel)))
    {
      alert("Nieprawidłowy numer PESEL")
      return false;
    }
    if (!(validateAccNum(acc_number)))
    {
      alert("Nieprawidłowy numer konta")
      return false;
    }
    if (!(validateEmail(email)))
    {
      alert("Nieprawidłowy adres email")
      return false;
    }
    if (!(validateBirthDate(daybirthdate,monthbirthdate,yearbirthdate)))
    {
      alert("Nieprawidłowa data urodzenia")
      return false;
    }
  }
  function validateAccNum(acc_number){
    var accregexp = /^[0-9]{26}$/;
    if (accregexp.test(acc_number))
      return true;
    else
      return false;
  }

  function validateEmail(email) {
    var emailregexp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    if (emailregexp.test(email))
        return true;
    else 
        return false;
  }

  function validateBirthDate(daybirthdate,monthbirthdate,yearbirthdate) {
      var daybirthregexp = /^[0-9]{2}$/;
      var monthbirthregexp = /^[0-9]{2}$/;
      var yearbirthregexp = /^[0-9]{4}$/;
      if (daybirthregexp.test(daybirthdate) && daybirthdate < 32)
            if (monthbirthregexp.test(monthbirthdate) && monthbirthdate < 13 && monthbirthdate > 0)
                if (yearbirthregexp.test(yearbirthdate))
                    return true;
      return false;
  }      


  
  function validatePesel(pesel){
    var regexp = /^[0-9]{11}$/;
    if(regexp.test(pesel))     //sprawdzenie, czy pesel sklada sie z 11 cyfr
    {  
      if ((pesel[2] % 2 == 1 && pesel[3] > 2) || (parseInt(pesel.substring(2,4))) % 20 == 0) //dozwolone przedzialy miesiaca: 1-12, 21-32, 41-52, 61-72, 81-92
        return false;
        
      if (parseInt(pesel.substring(4,6)) > 31) // dzien od 0 do 31
        return false;
      if (!check_sum(pesel))
        return false;
      
      return true;
      }
    else
    {
      return false;
    }
  }    
  function check_sum(pesel)      // 9×a + 7×b + 3×c + 1×d + 9×e + 7×f + 3×g + 1×h + 9×i + 7×j == cyfrze kontrolnej
  { 
   var sum = 9 * parseInt(pesel[0]) + 7 * parseInt(pesel[1]) + 3 * parseInt(pesel[2]) + parseInt(pesel[3]) + 9 * parseInt(pesel[4]) + 7 * parseInt(pesel[5]) + 3 * parseInt(pesel[6]) + parseInt(pesel[7]) + 9 * parseInt(pesel[8]) + 7 * parseInt(pesel[9])
    if (sum % 10 == pesel[10])
      return true;
    else
      return false;  
  }