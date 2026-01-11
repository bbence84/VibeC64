const script = document.createElement('script');
script.src = 'https://www.googletagmanager.com/gtag/js?id=G-64XNXQW49P'; // URL of the remote file
script.onload = () => {
  console.log('Analytics script loaded successfully.');
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-64XNXQW49P');  
};
script.onerror = () => {
  console.error('Error loading analytics script.');
};
document.head.appendChild(script);