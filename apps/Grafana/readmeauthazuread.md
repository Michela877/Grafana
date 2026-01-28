1️⃣ Prerequisiti: registrare l’app su Azure AD

Prima di tutto devi avere un’app registrata nel tuo tenant Azure AD / Entra ID:

1 Vai su Azure Portal → Azure Active Directory → App registrations → New registration

2 Nome: ad esempio Grafana-Prod

3 Redirect URI: https://<grafana-domain>/login/azuread

4 Dopo la creazione, prendi nota di:

  -Application (client) ID → Client ID

  -Directory (tenant) ID → Tenant ID

5 Genera un Client Secret sotto Certificates & Secrets → noterai un valore che userai in Grafana

2️⃣ Configurazione da web in Grafana

Nel pannello di Grafana (Configuration → Authentication → Azure AD → OAuth) compila i campi:

Campo	Cosa mettere
Display name	“Azure AD” o quello che vuoi far vedere sul login
Client authentication	Client secret
Client ID	Client ID dell’app Azure AD
Client secret	Il secret generato su Azure
Scopes	openid,email,profile
Auth URL	https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/authorize
Token URL	https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token
Allow sign up	Abilita se vuoi permettere a utenti nuovi di registrarsi automaticamente
Auto login	Abilita se vuoi bypassare la login page di Grafana (opzionale)
Sign out redirect URL	URL dove mandare l’utente dopo il logout (opzionale)

Puoi lasciare TLS, PKCE, refresh token e altri campi avanzati ai valori di default a meno che tu non abbia esigenze particolari di sicurezza.

3️⃣ Mapping utenti e ruoli (opzionale ma consigliato)

User mapping / Role attribute strict mode: per far sì che Grafana estragga i ruoli dai claim Azure AD

Organization mapping: puoi mappare gruppi AD in ruoli Grafana, ad esempio:

my-team:1:Viewer
dev-team:2:Editor


Allow assign Grafana admin: se vuoi che un gruppo Azure AD diventi automaticamente admin Grafana

4️⃣ Abilitazione

Premi Save and enable → Grafana ora abiliterà Azure AD OAuth2

Dopo il salvataggio, prova a fare Logout → Login e vedrai il pulsante Sign in with Azure AD nella schermata di login

🔹 Note aggiuntive

Se stai usando Grafana su Kubernetes, puoi fare la stessa configurazione tramite variabili d’ambiente per renderla persistente e riproducibile:

GF_AUTH_AZUREAD_ENABLED=true
GF_AUTH_AZUREAD_CLIENT_ID=<client-id>
GF_AUTH_AZUREAD_CLIENT_SECRET=<client-secret>
GF_AUTH_AZUREAD_TENANT_ID=<tenant-id>


UI vs variabili: la configurazione via UI viene salvata nel database interno di Grafana, quindi se ricrei il pod o il cluster, dovrai esportarla o rifarla.