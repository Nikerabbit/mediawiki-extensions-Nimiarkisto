<?php
declare( strict_types = 1 );

namespace MediaWiki\Extensions\Nimiarkisto;

use HTMLForm;
use MailAddress;
use MediaWiki\Config\Config;
use SpecialPage;
use UserMailer;

class RequestVanishSpecialPage extends SpecialPage {
	public function __construct( private readonly Config $config ) {
		parent::__construct( 'RequestVanish' );
	}

	public function execute( $par ): void {
		$this->setHeaders();
		$request = $this->getRequest();
		$output = $this->getOutput();
		$this->requireLogin();
		$this->checkPermissions();

		if ( $request->wasPosted() ) {
			$this->handleSubmit( $request->getText( 'wpexplanation' ) );
		} else {
			$output->addWikiMsg( 'requestvanish-description' );
			$this->displayForm();
		}
	}

	private function displayForm() {
		$formDescriptor = [
			'explanation' => [
				'type' => 'textarea',
				'label-message' => $this->msg( 'requestvanish-explanation-label' ),
				'rows' => 10,
				'required' => true,
			],
		];

		HTMLForm::factory( 'ooui', $formDescriptor, $this->getContext() )
			->setMethod( 'post' )
			->setId( 'mw-requestvanish-form' )
			->setWrapperLegend( false )
			->setSubmitTextMsg( 'requestvanish-submit' )
			->prepareForm()
			->displayForm( false );
	}

	private function handleSubmit( $explanation ) {
		$emailRecipient = $this->config->get( 'AccountVanishNotificationEmail' );
		$currentUser = $this->getUser();
		$subject = $this->msg( 'requestvanish-subject', $currentUser->getName() )->plain();
		$body = $this->msg( 'requestvanish-body', $currentUser->getName(), $explanation )->plain();

		$to = new MailAddress( $emailRecipient );
		$from = new MailAddress( $this->config->get( 'PasswordSender' ) );
		$status = UserMailer::send( $to, $from, $subject, $body );

		if ( $status->isOK() ) {
			$this->getOutput()->addWikiMsg( 'requestvanish-submit-success' );
		} else {
			$this->getOutput()->addWikiMsg( 'requestvanish-submit-error' );
		}
	}
}
