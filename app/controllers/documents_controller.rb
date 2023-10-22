# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    cadastral_reference = params[:document][:cadastral_reference]
    document = Document.find_by(cadastral_reference: cadastral_reference)

    unless document
      scraped_data = scrape_website(cadastral_reference)

      document = Document.create(
        cadastral_reference: cadastral_reference,
        year: scraped_data[:year],
        address: scraped_data[:address],
        template_id: rand(1..5)
      )
    end
    redirect_to preshow_document_path(document)
  end

  def preshow
    @document = Document.find(params[:id])
  end

  def show
    authenticate_user(params[:id])

    if (document = Document.find_by(id: params[:id]))
      @document = document

      respond_to do |format|
        format.html
        format.pdf do
          if current_user && current_user.purchased_documents.include?(params[:id].to_i)
            render pdf: 'show' # Excluding ".pdf" extension.
          end
        end
      end
    else
      redirect_to root_path
    end
  end

  def purchase_intent

    document_id = params[:document_id].to_i
    amount_in_cents = 4900 # Adjust this based on your requirements
    purchase_token = SecureRandom.hex(16)

    current_user.update(purchase_token: purchase_token)

    stripe_service = StripeService.new(current_user)
    intent = stripe_service.create_payment_intent(amount_in_cents, document_id, request.base_url)

    redirect_to intent.url, allow_other_host: true
  end

  private

  def scrape_website(cadastral_reference)
    page_url = "https://www1.sedecatastro.gob.es/cycbieninmueble/OVCConCiud.aspx?UrbRus=U&RefC=#{cadastral_reference}&esBice=&RCBice1=&RCBice2=&DenoBice=&from=OVCBusqueda&pest=rc&RCCompleta=5628108UF2452N0005QU&final=&del=29&mun=69"

    page_content = RestClient.get(page_url)
    parsed_content = Nokogiri::HTML(page_content)

    year = parsed_content&.css('.control-label.black.text-left')&.at(5)&.children&.last&.text&.strip || 'N/A'
    adr_1 = parsed_content&.css('.control-label.black.text-left')&.at(6)&.children&.first&.presence&.text&.strip || ''
    adr_2 = parsed_content&.css('.control-label.black.text-left')&.at(6)&.children&.last&.presence&.text&.strip || ''

    address = "#{adr_1} #{adr_2}".strip.upcase.presence || 'N/A'

    {
      year: year,
      address: address
    }
  end

  def authenticate_user(id = nil)
    redirect_to new_user_registration_path(document_id: id) unless current_user
  end
end
