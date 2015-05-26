<div class='bg-white'>
	<div class='container faq-title'>
		<div class='row'>
			<div class='col-xs-8 col-xs-offset-2 text-center'>
				<h2>Contact Us</h2>
			</div>
			<hr class='col-xs-10 col-xs-offset-1'>
		</div>

		<div class='row'>
			<div class='col-sm-8 col-sm-offset-2'>
				<form name='contactForm' class='contact-form form-horizontal' ng-submit="submitContactForm()">
					<div class='form-group'>
						<div class='col-sm-6'>
							<input class='form-control' type='email' name='email' placeholder='Email' ng-model='contact.email'>
						</div>
						<div class='col-sm-6'>
							<input class='form-control' type='text' name='name' placeholder='Full name' ng-model='contact.name'>
						</div>
					</div>
					<div class='form-group'>
						<div class='col-sm-12'>
							<textarea class='form-control' type='text' rows='7' name='message' placeholder='Message'  ng-model='contact.message'/>
						</div>
					</div>
					<div class='form-group'>
						<div class='col-sm-4'>
							<div id='recaptcha'></div>
						</div>
						<div class='col-sm-4 col-sm-offset-4'>
							<button type='submit' class='btn btn-block btn-success contact-btn' ng-disabled='contactForm.$invalid'>Send!</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>